class Pet < ActiveRecord::Base
  belongs_to :owner
  has_many :attachments, :as => :attachable
  has_many :adoption_requests
  accepts_nested_attributes_for :attachments

  #auto-fetch address
  geocoded_by  :area#, :latitude, :longitude #:address => :area
  #after_validation :reverse_geocode
  after_validation :geocode


  def self.get_pets_to_show(pet_params)
    p "========pet params======================="
    p pet_params
    pet = self.near([pet_params["latitude"],pet_params["longitude"]])
    # if pet_params["pet_breed"].present?
    #   pet = pet.where(:breed => pet_params["pet_breed"])
    # elsif pet_params["pet_type"].present?
    #   pet = pet.where(:pet_type => pet_params["pet_type"] )
    if pet_params["pet_type"].present? && pet_params["pet_breed"].present?
      pet = pet.where(:breed => pet_params["pet_breed"], :pet_type => pet_params["pet_type"] )
    elsif
      pet = pet.where(:breed => pet_params["pet_breed"], :pet_type => pet_params["pet_type"] )
    else
      pet
    end
    pet
  end
  
  def self.get_pets(params)

    pet_params = filtering_params(params)
    results = self.where(nil)
    pet_params.each do |key, value|
      results = results.where(key => value) if value.present?
    end
    results
  end
  def self.filtering_params(params)
    params.slice(:pet_type, :breed, :color)
  end

end
