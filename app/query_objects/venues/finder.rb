module Venues
  class Finder
    def initialize(params)
      @treatment = params[:treatment]
      @location = params[:location]
      @date = params[:date].try(:to_datetime)
      @rating = params[:rating]
      @cost = params[:cost].to_i
      @distance = params[:distance].to_i
    end

    def call
      query
    end

    private

    def pros
      treatment_query = @treatment.to_s.split.map { |s| s.tr!("*", "%") || "%#{s}%" }
      treatments = ::Treatment.arel_table

      if @treatment.blank? && @cost == 0
        Pro.all
      elsif @cost == 0
        @pros = Pro
          .joins(:treatments)
          .where(treatments[:treatment_type].matches_all(treatment_query))
      elsif @treatment.blank?
        @pros = Pro
          .joins(:treatments)
          .where(treatments[:sale_price].lteq(@cost))
      else
        @pros = Pro
          .joins(:treatments)
          .where(treatments[:treatment_type].matches_all(treatment_query)
            .and(treatments[:sale_price].lteq(@cost)))
      end
    end

    def query
      @query ||= Venue.order(created_at: :desc)

      location = @location.to_s.split.map { |s| s.tr!("*", "%") || "%#{s}%" }
      venues = ::Venue.arel_table
      (@query = @query.where(venues[:address].matches_all(location))) unless location.blank?
      
      near_location_search
      @query = @query.uniq.map { |venue| multicase(venue) }.compact

      @query
    end

    def near_location_search
      @near = []
      @query.each do |ven|
        @near += Venue.near(ven.address, @distance)
      end
      @query += @near
    end

    def multicase(venue)
      venue if pros_case?(venue) && date_case?(venue) && rating_case?(venue)
    end

    def pros_case?(venue)
      pros.uniq.include?(venue.pro)
    end

    def date_case?(venue)
      !@date || date_available_for?(venue)
    end

    def rating_case?(venue)
      @rating.blank? || venue.rating_more(@rating.to_i)
    end

    def date_available_for?(venue)
      slots_base = Bookings::AvailableSlotsFinder.new(@date, nil, venue.pro)
      !(slots_base.am_slots + slots_base.pm_slots).blank?
    end
  end
end
