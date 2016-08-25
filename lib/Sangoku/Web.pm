package Sangoku::Web {

  use Sangoku;
  use Mojo::Base 'Mojolicious';

  sub startup {
    my $self = shift;

    $self->setup_router();
  }

  sub setup_router {
    my ($self) = @_;

    my $r = $self->routes;
    $r->namespaces(['Sangoku::Web::Controller']);

    # root
    $r->get('/')->to('Root#root');

    # /outer
    {
      my $outer = $r->any('/outer'        )->to(controller => 'Outer');
      $outer->get('/player-list'          )->to(action => 'player_list');
      $outer->get('/map'                  )->to(action => 'map');
      $outer->get('/ranking'              )->to(action => 'ranking');
      $outer->get('/compare-country-power')->to(action => 'compare_country_power');     # グラフ
      $outer->get('/manual'               )->to(action => 'manual');
      $outer->get('/change-log'           )->to(action => 'change_log');
      $outer->get('/history'              )->to(action => 'history');
      $outer->get('/icon-list'            )->to(action => 'icon_list'); # JSでアイコン指定できるようにする(at regist, config-change-icon)

      # /outer/regist
      {
        my $regist = $outer->any('/regist')->to(controller => 'Outer::Regist');
        $regist->get( '/'      )->to(action => 'root');
        $regist->post('/regist')->to(action => 'regist');
      }

      # /outer/forum
      {
        my $forum = $outer->any('/forum')->to(controller => 'Outer::Forum');
        $forum->get( '/'          )->to(action => 'root');
        $forum->post('/write'     )->to(action => 'write');
        $forum->post('/new-thread')->to(action => 'new_thread');
      }
    }

    # /player
    {
      my $player = $r->any('/player')->to(controller => 'Player');
      $player->post('/logout')->to(action => 'logout');
      my $auth = $player->under->to(action => 'auth');
      $auth->any('/command-log')->to(action => 'command_log');

      # /player/mypage
      {
        my $mypage = $auth->any('/mypage')->to(controller => 'Player::Mypage');
        $mypage->any( '/'       )->to(action => 'root');
        $mypage->post('/channel')->to(action => 'channel');

        # /player/mypage/command
        {
          my $command = $mypage->any('/command')->to(controller => 'Player::Mypage::Command');
          $command->any( '/'      )->to(action => 'root');
          $command->post('/input ')->to(action => 'input');
          $command->post('/select')->to(action => 'select');
        }
      }

      # /player/letter
      {
        my $letter = $auth->any('/letter')->to(controller => 'Player::Letter');
        $letter->any( '/'        )->to(action => 'root');
        $letter->post('/channel' )->to(action => 'channel');
        $letter->any( '/personal')->to(action => 'personal');
        $letter->post('/send'    )->to(action => 'send');
      }

      # /player/config
      {
        my $config = $auth->any('/config')->to(controller => 'Player::Config');
        $config->any( '/'                      )->to(action => 'root'); # 戦績も一緒に表示
        $config->post('/change-icon'           )->to(action => 'change_icon');
        $config->post('/change-equipments-name')->to(action => 'change_equipments-name');
        $config->post('/change-loyalty'        )->to(action => 'change_loyalty');
        $config->post('/change-win-message'    )->to(action => 'change_win_message');
        $config->post('/set-profile'           )->to(action => 'set_profile');
        $config->post('/set-twitter'           )->to(action => 'set_twitter');
      }

      # /player/idle-talk
      {
        my $idle_talk = $auth->any('/idle_talk')->to(controller => 'Player::IdleTalk');
        $idle_talk->any( '/'       )->to(action => 'root');
        $idle_talk->post('/channel')->to(action => 'channel');
      }

      # /player/icon-uploader
      {
        my $icon_uploader = $auth->any('/icon-uploader')->to(controller => 'Player::IconUploader');
        $icon_uploader->any( '/'                 )->to(action => 'root');
        $icon_uploader->any( '/input-upload-icon')->to(action => 'input_upload_icon');
        $icon_uploader->post('/upload-icon'      )->to(action => 'upload_icon');
        $icon_uploader->any( '/input-search-icon')->to(action => 'input_search_icon');
        $icon_uploader->post('/search-icon'      )->to(action => 'search_icon');
      }

      # /player/town
      {
        my $town = $auth->any('/town')->to(controller => 'Player::Town');
        $town->any('/player-list')->to(action => 'player_list');
      }

      # /player/unit
      {
        my $unit = $auth->any('/unit')->to(controller => 'Player::Unit');
        $unit->get( '/'           )->to(action => 'root');
        $unit->post('/create'     )->to(action => 'create');
        $unit->post('/join'       )->to(action => 'join');
        $unit->post('/quit'       )->to(action => 'quit');
        $unit->post('/break'      )->to(action => 'break');
        $unit->post('/fire'       )->to(action => 'fire');
        $unit->post('/join-permit')->to(action => 'join_permit');
        $unit->post('/change-info')->to(action => 'change_info');
      }

      # /player/country
      {
        my $country = $auth->any('/country')->to(controller => 'Player::Country');
        $country->any('/'          )->to(action => 'root');
        $country->any('/member'    )->to(action => 'member');
        $country->any('/conference')->to(action => 'conference');
        $country->any('/law'       )->to(action => 'law');

        # /player/country/headquarters
        {
          my $headquarters = $country->any('/headquarters')->to(controller => 'Player::Country::HeadQuarters');
          $headquarters->any( '/'                      )->to(action => 'root');
          $headquarters->post('/fire-people'           )->to(action => 'fire_people');
          $headquarters->post('/set-command'           )->to(action => 'set_command');
          $headquarters->post('/usurp-king'            )->to(action => 'usurp_king');
          $headquarters->post('/appoint-position'      )->to(action => 'appoint_position');
          $headquarters->post('/set-invitation-message')->to(action => 'set_invitation_message');
          $headquarters->post('/make-statement'        )->to(action => 'make_statement');
          $headquarters->post('/change-color'          )->to(action => 'change_color');

          # /player/country/headquarters/diplomacy
          {
            my $diplomacy = $headquarters->any('/diplomacy')->to(controller => 'Player::Country::HeadQuarters::Diplomacy');
            $diplomacy->get( '/'                                   )->to(action => 'root');
            $diplomacy->post('/declare-war'                        )->to(action => 'declare_war');
            $diplomacy->post('/short-declare-war'                  )->to(action => 'short_declare_war');
            $diplomacy->post('/request-stop-war'                   )->to(action => 'request_stop_war');
            $diplomacy->post('/request-cession-or-accept-territory')->to(action => 'request_cession_or_accept_territory');
          }
        }
      }

    }

    # /admin
    {
      my $admin = $r->any('/admin')->to(controller => 'Admin');
      $admin->any( '/')->to(action => '');
      $admin->any( '/comfirm-reset-game')->to(action => 'comfirm_reset_game');
      $admin->post('/reset-game')->to(action => 'reset_game');
      $admin->any( '/input-edit-player')->to(action => 'reset_game');
      $admin->post('/edit-player')->to(action => 'comfirm_reset_game');
    }

    # /api
    {
      my $api = $r->any('/v1/api')->to(controller => 'V1::API');
    }

  }

}

1;
