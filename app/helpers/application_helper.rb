module ApplicationHelper
  def current_url
    "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
  end

  def current_site
    ENV["APP_NAME"]
  end

  def current_title
    title = []
    title << current_site
    title << if content_for?(:title)
      content_for(:title)
    else
      params[:controller].split("/").last.titleize
    end
    title.uniq.join(" | ")
  end

  def meta_tag(tag, text)
    content_for :"meta_#{tag}", text
  end

  def yield_meta_tag(tag, default_text = "")
    content_for?(:"meta_#{tag}") ? content_for(:"meta_#{tag}") : default_text
  end

  def title(elements = [])
    content_for :title, elements.compact.map { |a| a.try(:name) || a.try(:title) || a.try(:id) || a.to_s.capitalize }.join(" | ")
  end

  def description(description = "")
    content_for :description, description
  end

  def sanitize(content)
    ActionController::Base.helpers.sanitize(content)
  end

  def strip_tags_and_entities(string)
    unless string.blank?
      stripped = strip_tags(string)
      decoded = HTMLEntities.new.decode(stripped)
      decoded.squish.gsub(%r{/</?[^>]*>/}, "")
    end
  end

  def route_exists?(path)
    recognize_path = Rails.application.routes.recognize_path(path, method: :get)
    recognize_path.present? && recognize_path[:action] != "route_not_found"
  rescue
    false
  end

  def content_for_or(name, default)
    if content_for?(name)
      content_for(name)
    else
      default
    end
  end

  def body_class(params)
    body = []
    return unless params[:controller]
    if params[:controller].include?("/")
      body << params[:controller].split("/").first
      body << params[:controller].tr("/", "-")
    else
      body << params[:controller]
    end
    body << if params[:controller].include?("/")
      "#{params[:controller].tr("/", "-")}-#{params[:action]}"
    else
      "#{params[:controller]}-#{params[:action]}"
    end
    if params.key?(:page)
      body << "#{params[:controller]}-#{params[:action]}-#{params[:page]}"
    end
    body.join(" ")
  end
end
