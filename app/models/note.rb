class Note < ActiveRecord::Base
  attr_accessible :note_text
  belongs_to :person
end