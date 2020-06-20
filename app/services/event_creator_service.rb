# frozen_string_literal: true

class EventCreatorService < ApplicationService
  attr_accessor :custom_fields

  def initialize(fields = {})
    @custom_fields = fields.to_h
  end

  def call
    remove_constant

    class_fields = fields
    klass = Class.new(Event) do
      class_fields.each do |item|
        field item[:name], type: item[:type]
      end
    end

    Object.const_set('CustomEvent', klass)
  end

  private

  def fields
    custom_fields.map do |option, _value|
      { name: option, type: String }
    end
  end

  def remove_constant
    return unless Object.constants.include?('CustomEvent')

    Object.send(:remove_const, 'CustomEvent')
  end
end
