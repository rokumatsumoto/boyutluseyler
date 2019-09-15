# frozen_string_literal: true

module HeroHelper
  include Boyutluseyler::Utils::StrongMemoize

  def use_hero?
    return false if partial_name.blank?

    true
  end

  def hero(anonymous_partial, logged_in_partial)
    self.anonymous_partial = anonymous_partial
    self.logged_in_partial = logged_in_partial

    hero_partial_path
  end

  private

  def hero_partial_path
    "#{partial_base_path}/#{partial_name}"
  end

  def partial_base_path
    'layouts/hero'
  end

  def partial_name
    strong_memoize(:partial_name) do
      if current_user
        logged_in_partial
      else
        anonymous_partial
      end
    end
  end

  def anonymous_partial=(anonymous_partial)
    @anonymous_partial = anonymous_partial
  end

  def logged_in_partial=(logged_in_partial)
    @logged_in_partial = logged_in_partial
  end

  def anonymous_partial
    @anonymous_partial ||= ''
  end

  def logged_in_partial
    @logged_in_partial ||= ''
  end
end
