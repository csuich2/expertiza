class SubmittedContentLink < ActiveRecord::Base
  # Returns submitted content links by a particular participant
  def SubmittedContentLink.get_submitted_links  participant_id
     links = self.find_all_by_participant_id(participant_id)
  end
end
