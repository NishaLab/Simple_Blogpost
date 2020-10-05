# frozen_string_literal: true

module MicropostsHelper
  def get_all_reaction_by_image_id(micropost_id, id)
    Reaction.where(micropost_id: micropost_id, image_id: id)
  end
end
