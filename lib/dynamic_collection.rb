# frozen_string_literal: true

class DynamicCollection
  def self.create(collection, fields)
    if Object.constants.include?(collection)
      Object.send(:remove_const, collection)
    end

    klass = Class.new do
      include Mongoid::Document
      store_in collection: collection.downcase

      fields.each do |item|
        field item[:name], type: item[:type]
      end
    end

    Object.const_set(collection, klass)
  end
end
