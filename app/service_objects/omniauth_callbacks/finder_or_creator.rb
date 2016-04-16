module OmniauthCallbacks
  class FinderOrCreator
    def initialize(auth)
      @auth = auth
    end

    def call
      return authorization.consumer if authorization

      if consumer = Consumer.find_by(email: email)
        consumer.authorizations.create(provider: @auth.provider, uid: @auth.uid)
        consumer
      else
        create_consumer_with_auth(email)
      end
    end

    private

    def create_consumer_with_auth(email)
      first_name, last_name = @auth.info.name.split("\s", 2)
      profile_name = SecureRandom.urlsafe_base64(nil, false)
      password = Devise.friendly_token[0, 20]
      consumer = Consumer.create!(email: email,
                          password: password,
                          password_confirmation: password,
                          profile_name: profile_name,
                          first_name: first_name,
                          last_name: last_name)
      consumer.authorizations.create(provider: @auth.provider, uid: @auth.uid)
      consumer
    end

    def authorization
      @authorization ||= Authorization.find_by(provider: @auth.provider, uid: @auth.uid.to_s)
    end

    def email
      @email ||= (@auth.info.email || "#{@auth.uid}@fromtwitter.com")
    end
  end
end
