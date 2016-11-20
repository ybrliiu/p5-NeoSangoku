package Sangoku::DB::Schema {

  # generate from script/teng_schema_duper.pl
  # and define row_class

  use Sangoku;
  use Teng::Schema::Declare;
  
  table {
    name 'country';
    pk 'name';
    columns (
      {name => 'name', type => -1},
      {name => 'color', type => -1},
      {name => 'continue_year', type => 4},
      {name => 'command_message', type => -1},
      {name => 'invitation_message', type => -1},
    );
  };

  table {
    name 'country_conference_reply';
    pk 'id';
    columns (
      {name => 'country_name', type => -1},
      {name => 'thread_id', type => 4},
      {name => 'id', type => 4},
      {name => 'name', type => -1},
      {name => 'message', type => -1},
      {name => 'icon', type => 4},
      {name => 'time', type => -1},
    );
    row_class 'Sangoku::DB::Row::Country::ConferenceReply';
  };

  table {
    name 'country_conference_thread';
    pk 'id';
    columns (
      {name => 'country_name', type => -1},
      {name => 'id', type => 4},
      {name => 'title', type => -1},
      {name => 'name', type => -1},
      {name => 'message', type => -1},
      {name => 'icon', type => 4},
      {name => 'time', type => -1},
    );
    row_class 'Sangoku::DB::Row::Country::ConferenceThread';
  };

  table {
    name 'country_law';
    pk 'id';
    columns (
      {name => 'country_name', type => -1},
      {name => 'id', type => 4},
      {name => 'title', type => -1},
      {name => 'name', type => -1},
      {name => 'message', type => -1},
    );
    row_class 'Sangoku::DB::Row::Country::Law';
  };

  table {
    name 'country_letter';
    pk 'id';
    columns (
      {name => 'country_name', type => -1},
      {name => 'id', type => 4},
      {name => 'sender_name', type => -1},
      {name => 'sender_icon', type => 4},
      {name => 'sender_town_name', type => -1},
      {name => 'sender_country_name', type => -1},
      {name => 'receiver_name', type => -1},
      {name => 'message', type => -1},
      {name => 'time', type => -1},
    );
    row_class 'Sangoku::DB::Row::Country::Letter';
  };

  table {
    name 'country_position';
    pk 'country_name';
    columns (
      {name => 'country_name', type => -1},
      {name => 'king_id', type => -1},
      {name => 'premier_id', type => -1},
      {name => 'strategist_id', type => -1},
      {name => 'great_general_id', type => -1},
      {name => 'cavalry_general_id', type => -1},
      {name => 'guard_general_id', type => -1},
      {name => 'archery_general_id', type => -1},
      {name => 'infantry_general_id', type => -1},
    );
    row_class 'Sangoku::DB::Row::Country::Position';
  };

  table {
    name 'country_diplomacy';
    pk 'type','request_country','receive_country';
    columns (
      {name => 'type', type => -1},
      {name => 'is_accepted', type => 4},
      {name => 'request_country', type => -1},
      {name => 'receive_country', type => -1},
      {name => 'start_year', type => 4},
      {name => 'start_month', type => 4},
      {name => 'option', type => -1},
    );
    row_class 'Sangoku::DB::Row::Country::Diplomacy';
  };

  table {
    name 'country_members';
    pk 'player_id';
    columns (
      {name => 'player_id', type => -1},
      {name => 'country_name', type => -1},
    );
    row_class 'Sangoku::DB::Row::Country::Members';
  };

  table {
    name 'forum_reply';
    pk 'id';
    columns (
      {name => 'thread_id', type => 4},
      {name => 'id', type => 4},
      {name => 'name', type => -1},
      {name => 'message', type => -1},
      {name => 'icon', type => 4},
      {name => 'time', type => -1},
    );
  };

  table {
    name 'forum_thread';
    pk 'id';
    columns (
      {name => 'id', type => 4},
      {name => 'title', type => -1},
      {name => 'name', type => -1},
      {name => 'message', type => -1},
      {name => 'icon', type => 4},
      {name => 'time', type => -1},
    );
  };

  table {
    name 'icon_uploader';
    pk 'id';
    columns (
      {name => 'id', type => 4},
      {name => 'tag', type => -1},
      {name => 'time', type => -1},
    );
  };

  table {
    name 'idle_talk';
    pk 'id';
    columns (
      {name => 'id', type => 4},
      {name => 'name', type => -1},
      {name => 'icon', type => 4},
      {name => 'message', type => -1},
      {name => 'time', type => -1},
    );
  };

  table {
    name 'announce';
    pk 'id';
    columns (
      {name => 'id', type => 4},
      {name => 'date', type => -1},
      {name => 'message', type => -1},
    );
  };

  table {
    name 'player';
    pk 'id';
    columns (
      {name => 'id', type => -1},
      {name => 'name', type => -1},
      {name => 'pass', type => -1},
      {name => 'icon', type => 4},
      {name => 'town_name', type => -1},
      {name => 'force', type => 4},
      {name => 'intellect', type => 4},
      {name => 'leadership', type => 4},
      {name => 'popular', type => 4},
      {name => 'loyalty', type => 4},
      {name => 'update_time', type => -5},
      {name => 'force_exp', type => 4},
      {name => 'intellect_exp', type => 4},
      {name => 'leadership_exp', type => 4},
      {name => 'popular_exp', type => 4},
      {name => 'mail', type => -1},
      {name => 'win_message', type => -1},
      {name => 'ip_after', type => -1},
      {name => 'ip', type => -1},
      {name => 'money', type => 4},
      {name => 'rice', type => 4},
      {name => 'class', type => 4},
      {name => 'sp', type => 4},
      {name => 'contribute', type => 4},
      {name => 'update_check', type => 4},
      {name => 'delete_turn', type => 4},
    );
  };

  table {
    name 'player_battle_record';
    pk 'player_id';
    columns (
      {name => 'player_id', type => -1},
      {name => 'attack_win', type => 4},
      {name => 'attack_lose', type => 4},
      {name => 'guard_win', type => 4},
      {name => 'guard_lose', type => 4},
      {name => 'draw', type => 4},
      {name => 'kill_people', type => 4},
      {name => 'die_people', type => 4},
      {name => 'conquer_town', type => 4},
      {name => 'attack_town', type => 4},
      {name => 'wall_destroy', type => 4},
    );
    row_class 'Sangoku::DB::Row::Player::BattleRecord';
  };

  table {
    name 'player_book';
    pk 'player_id';
    columns (
      {name => 'player_id', type => -1},
      {name => 'name', type => -1},
      {name => 'power', type => 4},
      {name => 'skill_category', type => -1},
      {name => 'skill_name', type => -1},
      {name => 'skill2_category', type => -1},
      {name => 'skill2_name', type => -1},
    );
    row_class 'Sangoku::DB::Row::Player::Book';
  };

  table {
    name 'player_command_record';
    pk 'player_id','command_name';
    columns (
      {name => 'player_id', type => -1},
      {name => 'command_name', type => -1},
      {name => 'execute_count', type => 4},
    );
    row_class 'Sangoku::DB::Row::Player::CommandRecord';
  };

  table {
    name 'player_config';
    pk 'player_id';
    columns (
      {name => 'player_id', type => -1},
    );
    row_class 'Sangoku::DB::Row::Player::Config';
  };

  table {
    name 'player_guard';
    pk 'player_id';
    columns (
      {name => 'player_id', type => -1},
      {name => 'name', type => -1},
      {name => 'power', type => 4},
      {name => 'skill_category', type => -1},
      {name => 'skill_name', type => -1},
      {name => 'skill2_category', type => -1},
      {name => 'skill2_name', type => -1},
    );
    row_class 'Sangoku::DB::Row::Player::Guard';
  };

  table {
    name 'player_invite';
    pk 'id';
    columns (
      {name => 'player_id', type => -1},
      {name => 'id', type => 4},
      {name => 'sender_name', type => -1},
      {name => 'sender_id', type => -1},
      {name => 'sender_icon', type => 4},
      {name => 'sender_town_name', type => -1},
      {name => 'sender_country_name', type => -1},
      {name => 'receiver_name', type => -1},
      {name => 'message', type => -1},
      {name => 'time', type => -1},
    );
    row_class 'Sangoku::DB::Row::Player::Invite';
  };

  table {
    name 'player_letter';
    pk 'id';
    columns (
      {name => 'player_id', type => -1},
      {name => 'id', type => 4},
      {name => 'letter_type', type => -1},
      {name => 'sender_name', type => -1},
      {name => 'sender_icon', type => 4},
      {name => 'sender_town_name', type => -1},
      {name => 'sender_country_name', type => -1},
      {name => 'receiver_name', type => -1},
      {name => 'message', type => -1},
      {name => 'time', type => -1},
    );
    row_class 'Sangoku::DB::Row::Player::Letter';
  };

  table {
    name 'player_skill';
    pk 'player_id','skill_category','skill_name';
    columns (
      {name => 'player_id', type => -1},
      {name => 'skill_category', type => -1},
      {name => 'skill_name', type => -1},
    );
    row_class 'Sangoku::DB::Row::Player::Skill';
  };

  table {
    name 'player_soldier';
    pk 'player_id';
    columns (
      {name => 'player_id', type => -1},
      {name => 'name', type => -1},
      {name => 'num', type => 4},
      {name => 'training', type => 4},
    );
    row_class 'Sangoku::DB::Row::Player::Soldier';
  };

  table {
    name 'player_weapon';
    pk 'player_id';
    columns (
      {name => 'player_id', type => -1},
      {name => 'name', type => -1},
      {name => 'power', type => 4},
      {name => 'skill_category', type => -1},
      {name => 'skill_name', type => -1},
      {name => 'skill2_category', type => -1},
      {name => 'skill2_name', type => -1},
    );
    row_class 'Sangoku::DB::Row::Player::Weapon';
  };

  table {
    name 'town';
    pk 'name';
    columns (
      {name => 'name', type => -1},
      {name => 'country_name', type => -1},
      {name => 'x', type => 4},
      {name => 'y', type => 4},
      {name => 'loyalty', type => 4},
      {name => 'farmer', type => 4},
      {name => 'farmer_max', type => 4},
      {name => 'farm', type => 4},
      {name => 'farm_max', type => 4},
      {name => 'business', type => 4},
      {name => 'business_max', type => 4},
      {name => 'technology', type => 4},
      {name => 'technology_max', type => 4},
      {name => 'wall', type => 4},
      {name => 'wall_max', type => 4},
      {name => 'wall_power', type => 4},
      {name => 'wall_power_max', type => 4},
      {name => 'price', type => 3},
    );
  };

  table {
    name 'town_letter';
    pk 'id';
    columns (
      {name => 'town_name', type => -1},
      {name => 'id', type => 4},
      {name => 'sender_name', type => -1},
      {name => 'sender_icon', type => 4},
      {name => 'sender_town_name', type => -1},
      {name => 'sender_country_name', type => -1},
      {name => 'receiver_name', type => -1},
      {name => 'message', type => -1},
      {name => 'time', type => -1},
    );
    row_class 'Sangoku::DB::Row::Town::Letter';
  };

  table {
    name 'town_guards';
    pk 'player_id';
    columns (
      {name => 'player_id', type => -1},
      {name => 'town_name', type => -1},
      {name => 'order', type => 4},
    );
    row_class 'Sangoku::DB::Row::Town::Guards';
  };

  table {
    name 'unit';
    pk 'id';
    columns (
      {name => 'id', type => 4},
      {name => 'leader_id', type => -1},
      {name => 'name', type => -1},
      {name => 'country_name', type => -1},
      {name => 'message', type => -1},
      {name => 'join_permit', type => 4},
      {name => 'auto_gather', type => 4},
    );
  };

  table {
    name 'unit_members';
    pk 'player_id';
    columns (
      {name => 'unit_id', type => 4},
      {name => 'player_id', type => -1},
      {name => 'player_name', type => -1},
      {name => 'country_name', type => -1},
    );
    row_class 'Sangoku::DB::Row::Unit::Members';
  };

  table {
    name 'unit_letter';
    pk 'id';
    columns (
      {name => 'unit_id', type => 4},
      {name => 'id', type => 4},
      {name => 'sender_name', type => -1},
      {name => 'sender_icon', type => 4},
      {name => 'sender_town_name', type => -1},
      {name => 'sender_country_name', type => -1},
      {name => 'receiver_name', type => -1},
      {name => 'message', type => -1},
      {name => 'time', type => -1},
    );
    row_class 'Sangoku::DB::Row::Unit::Letter';
  };

}

1;
