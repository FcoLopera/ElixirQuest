defmodule Elixirquest.Game.Item do
  @moduledoc """
  Item
  """

  defstruct [
    id: nil,
    item_id: nil,
    x: 0,
    y: 0,
    category: "item",
    content: [],      # content is the array of possible items in case of a chest, or the item itself in case of non-chest ;
                      # "item" will be the final content, randomly picked from "content" in setContent()
    respawn: false,   # can the item respawn after being piked (boolean)
    chest: false,     # is the item contained in a chest (boolean)
    in_chest: false,  # is the item currently within its chest, or has the chest been opened (boolean)
    loot: false,      # is the item some loot from a monster (boolean) ; only used client-side
    visible: false
  ]


  def trim(item) do
    %{ "id"       => item.id,
       "x"        => item.x,
       "y"        => item.y,
       "itemID"   => item.item_id,
       "visible"  => item.visible,
       "respawn"  => item.respawn,
       "chest"    => item.chest,
       "inChest"  => item.in_chest,
       "loot"     => item.loot
     }
  end


  #TODO dont forget about game object functions, need world get_aoi_from_tiles

  #GameObject.prototype.updateAOIs = function(property,value){
  #    // When something changes, all the AOI around the affected entity are updated
  #    var AOIs = this.listAdjacentAOIs(true);
  #    var category = this.category; // type of the affected game object: player, monster, item
  #    var id = this.id;
  #    AOIs.forEach(function(aoi){
  #        GameServer.updateAOIproperty(aoi,category,id,property,value);
  #    });
  #};
#
  #GameObject.prototype.getAOIid = function(){
  #    return GameServer.AOIfromTiles.getFirst(this.x,this.y).id;
  #};
#
  #GameObject.prototype.listAdjacentAOIs = function(onlyIDs){
  #    var current = this.getAOIid();
  #    var AOIs = AOIutils.listAdjacentAOIs(current);
  #    if(!onlyIDs) // return strings such as "AOI1", "AOI13", ... instead of just 1, 13, ...
  #    {
  #        AOIs = AOIs.map(function(aoi) {
  #            return "AOI" + aoi;
  #        });
  #    }
  #    return AOIs;
  #};
end
