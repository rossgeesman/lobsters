class << Rails.application
    def domain
      "sn.com"
    end

    def name
      "Social News"
    end
  end

  Rails.application.routes.default_url_options[:host] = Rails.application.domain