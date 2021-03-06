<!--
# ----------------------------------------------------------------------------
# Webinterface for the nerd-alarmclock.
#
# This file defines the content area for the radio-configuration.
#
# Author: Bernhard Bablok, Benjamin Fuchs
# License: GPL3
#
# Website: https://github.com/bablokb/nerd-alarmclock
#
# ----------------------------------------------------------------------------
-->

<!-- helper scripts   --------------------------------------------------   -->

<script  type="text/javascript">
  $(document).ready(function() {
    $('#id_radio_current_list').on('change',on_list_changed);
    $('#id_channels').on('change',on_channel_changed);
  });

  // event-handler: save current list and update channel-dropdown
  function on_list_changed(event) {
    var index = $(event.target).prop('selectedIndex');
    var name = nclock.lists['channel_lists'][index];
    nclock.radio["radio.current.list"] = name;
    fill_channels(index);
  };

  // event-handler: save index of current channel
  function on_channel_changed(event) {
    var index = $(event.target).prop('selectedIndex');
    var name = nclock.radio["radio.current.list"];
    var key  = "radio.channel."+name+".index";
    nclock.radio[key] = index;
  };

  function fill_channels(index) {
    $('#id_channels').empty();
    fill_list(nclock.lists.channels[index],$('#id_channels'),
                             function(element) {return element.name;}
              );
    var name = nclock.lists['channel_lists'][index];
    var key = "radio.channel."+name+".index";
    var value = nclock.lists.channels[index][nclock.radio[key]].name;
    set_value({"channels": value});
  };

  function read_radio_settings() {
    $.ajax({
      url: "/radio/read"
    }).then(function(data) {
      nclock.radio = data;
      // TODO: nclock.lists might not be available at this point
      index = data.hasOwnProperty("radio.current.list") ?
                nclock.lists.channel_lists.findIndex(function(name) {
                   return name === data["radio.current.list"];
                }) : 0;
      fill_channels(index);
      // server-settings -> UI
      set_value(data);
    });
  };

  // fill select-tag with options (triggered from main.tpl)
  function radio_fill_lists(data) {
    fill_list(data.channel_lists,$('#id_radio_current_list'));
  };

  // hook to run when tab is selected
  function on_select_tab_radio() {
    read_radio_settings();
  };
</script>

<!-- form for radio settings   -----------------------------------------   -->

<div id="id_content_radio" class="content">
  <form id="id_form_radio" method="post"
         class="w3-container w3-card-4 w3-light-grey w3-text-blue w3-margin">
    <fieldset>
      <legend>Channels</legend>
      <div class="w3-row-padding w3-section">
        <label for="id_channel_list" class="w3-col l1">Channel list</label>
        <!-- TODO: implement on_channel_lists_select() -->
        <select class="w3-select w3-col l1" id="id_radio_current_list"></select>
      </div>

      <div class="w3-row-padding w3-section">
        <label for="id_channels" class="w3-col l1">Channels</label>
        <select class="w3-select w3-col l1" id="id_channels"></select>
      </div>
    </fieldset>

    <div class="w3-section padding-top">
      <button type="submit" class="w3-button w3-round-xxlarge
               w3-border w3-border-blue">Save</button>
    </div>
  </form>
</div>

