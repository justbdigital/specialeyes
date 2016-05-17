module Venues
  class Finder
    def initialize(params)
      @treatment = params[:treatment]
      @location = params[:location]
      @date = params[:date].try(:to_datetime)
      @rating = params[:rating]
      @cost = params[:cost].to_i
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

    def date_available_for?(venue)
      slots_base = Bookings::AvailableSlotsFinder.new(@date, nil, venue.pro)
      !(slots_base.am_slots + slots_base.pm_slots).blank?
    end

    def sub_venue_query
      Venue.order(created_at: :desc)
    end

    def query
      @query ||= sub_venue_query.joins(:pro).where(pro: pros.uniq)

      location = @location.to_s.split.map { |s| s.tr!("*", "%") || "%#{s}%" }
      venues = ::Venue.arel_table
      (@query = @query.where(venues[:address].matches_all(location))) unless location.blank?

      (@query = @query.map { |venue| venue if date_available_for?(venue) }.compact) if @date
      (@query = @query.map { |venue| venue if venue.rating_more(@rating.to_i) }.compact) unless @rating.blank?
      @query
    end

    def filter
      location = @location.to_s.split.map { |s| s.tr!("*", "%") || "%#{s}%" }
      return query if location.blank?

      venues = ::Venue.arel_table
      query.where(venues[:address].matches_all(location))
    end
  end
end
