module Venues
  class Finder
    def initialize(params)
      @treatment = params[:treatment]
      @location = params[:location]
    end

    def call
      apply_filters(query)
    end

    private

    def pros
      Pro.where(::Treatment.arel_table[:title].matches_all(treatment))
    end

    def query
      Venue.order(created_at: :desc)
    end

    def apply_filters(query)
      treatment = @treatment.to_s.split.map { |s| s.tr!("*", "%") || "%#{s}%" }
      location = @location.to_s.split.map { |s| s.tr!("*", "%") || "%#{s}%" }

      filter(query, treatment, location)
    end

    def filter(query, treatment, location)
      return query if treatment.blank?
      venues = ::Venue.arel_table
      treatments = ::Treatment.arel_table

      pros = Pro.joins(:treatments).where(treatments[:title].matches_all(treatment))

      query.joins(:pro).where(pro: pros).where(venues[:address].matches_all(location))
    end
  end
end
