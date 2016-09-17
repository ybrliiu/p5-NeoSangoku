-- REFERENCES で外部キー制約、ON DELETE CASCADEで外部キー削除時に同時削除する
-- 下のSQL文をpsqlから入力& ../script/teng_schema_dumper.pl を実行、Sangoku::DB::Schema クラスを出力


-- 国関連テーブル
CREATE TABLE "country" (
  "name"  text PRIMARY KEY,
  "color" text DEFAULT '',
  "continue_year"       int DEFAULT 0,
  "command_message"     text DEFAULT '',
  "invitation_message"  text DEFAULT ''
);

CREATE TABLE "country_law" (
  "country_name" text REFERENCES "country" ("name") ON DELETE CASCADE,
  "id"    serial PRIMARY KEY,
  "title" text NOT NULL,
  "name" text NOT NULL,
  "message"   text NOT NULL
);

CREATE TABLE "country_conference_thread" (
  "country_name" text REFERENCES "country" ("name") ON DELETE CASCADE,
  "id" serial PRIMARY KEY,
  "title"   text NOT NULL,
  "name"    text NOT NULL,
  "message" text NOT NULL,
  "icon" int NOT NULL,
  "time" text NOT NULL
);

CREATE TABLE "country_conference_reply" (
  "country_name" text REFERENCES "country" ("name") ON DELETE CASCADE,
  "thread_id"    int REFERENCES "country_conference_thread" ON DELETE CASCADE,
  "id"      serial PRIMARY KEY,
  "name"    text NOT NULL,
  "message" text NOT NULL,
  "icon" int NOT NULL,
  "time" text NOT NULL
);

CREATE TABLE "country_letter" (
  "country_name" text REFERENCES "country" ("name") ON DELETE CASCADE,
  "id"        serial PRIMARY KEY,
  "sender_name" text NOT NULL,
  "sender_icon"  int NOT NULL,
  "sender_town_name"    text NOT NULL,
  "sender_country_name" text NOT NULL,
  "receiver_name"       text NOT NULL,
  "message" text NOT NULL,
  "time"    text NOT NULL
);

-- 外交データ
CREATE TABLE "country_diplomacy" (
  "type" text NOT NULL,
  "is_accepted" int DEFAULT 0,
  "request_country" text REFERENCES "country" ("name") ON DELETE CASCADE,
  "receive_country" text REFERENCES "country" ("name") ON DELETE CASCADE,
  "start_year" int NOT NULL,
  "start_month" int NOT NULL,
  "option" text DEFAULT '',
  PRIMARY KEY("type", "request_country", "receive_country")
);


-- 都市関連テーブル
CREATE TABLE "town" (
  "name" text PRIMARY KEY,
  "country_name" text NOT NULL,
  "x" int NOT NULL,
  "y" int NOT NULL,
  "loyalty" int DEFAULT 50,
  "farmer" int NOT NULL,
  "farmer_max" int NOT NULL,
  "farm" int NOT NULL,
  "farm_max" int NOT NULL,
  "business" int NOT NULL,
  "business_max" int NOT NULL,
  "technology" int NOT NULL,
  "technology_max" int NOT NULL,
  "wall" int NOT NULL,
  "wall_max" int NOT NULL,
  "wall_power" int NOT NULL,
  "wall_power_max" int NOT NULL,
  "price" numeric(4, 3) DEFAULT 1.0
);

CREATE TABLE "town_letter" (
  "town_name" text REFERENCES "town" ("name") ON DELETE CASCADE,
  "id"        serial PRIMARY KEY,
  "sender_name" text NOT NULL,
  "sender_icon"  int NOT NULL,
  "sender_town_name"    text NOT NULL,
  "sender_country_name" text NOT NULL,
  "receiver_name"       text NOT NULL,
  "message" text NOT NULL,
  "time"    text NOT NULL
);


-- プレイヤー関連テーブル
CREATE TABLE "player" (
  "id"   text PRIMARY KEY,
  "name" text UNIQUE NOT NULL,
  "pass" text NOT NULL,
  "icon" int  NOT NULL,
  "country_name" text NOT NULL,
  "town_name"    text NOT NULL,
  "force"      int NOT NULL,
  "intellect"  int NOT NULL,
  "leadership" int NOT NULL,
  "popular"    int NOT NULL,
  "loyalty"    int NOT NULL,
  "update_time"  bigint NOT NULL,

  "force_exp"      int DEFAULT 0,
  "intellect_exp"  int DEFAULT 0,
  "leadership_exp" int DEFAULT 0,
  "popular_exp"    int DEFAULT 0,
  "mail"        text DEFAULT '',
  "unit_id"     text DEFAULT '', -- 部隊ID, 部隊長のplayer_id
  "win_message" text DEFAULT '',
  "ip_after"    text DEFAULT '',
  "ip"          text DEFAULT '',
  "money" int DEFAULT 1000,
  "rice"  int DEFAULT 1000,
  "class" int DEFAULT 0,
  "sp"    int DEFAULT 0,
  "contribute"   int DEFAULT 0,
  "update_check" int DEFAULT 0,
  "delete_turn"  int DEFAULT 0
);

CREATE TABLE "player_config" (
  "player_id" text PRIMARY KEY REFERENCES "player" ("id") ON DELETE CASCADE
);

CREATE TABLE "player_weapon" (
  "player_id" text PRIMARY KEY REFERENCES "player" ("id") ON DELETE CASCADE,
  "name"   text DEFAULT '木刀',
  "power"  int  DEFAULT 0,
  "skill_category"  text DEFAULT '',
  "skill_name"      text DEFAULT '',
  "skill2_category" text DEFAULT '',
  "skill2_name"     text DEFAULT ''
);

CREATE TABLE "player_guard" (
  "player_id" text PRIMARY KEY REFERENCES "player" ("id") ON DELETE CASCADE,
  "name"   text DEFAULT '麻の服',
  "power"  int  DEFAULT 0,
  "skill_category"  text DEFAULT '',
  "skill_name"      text DEFAULT '',
  "skill2_category" text DEFAULT '',
  "skill2_name"     text DEFAULT ''
);

CREATE TABLE "player_book" (
  "player_id" text PRIMARY KEY REFERENCES "player" ("id") ON DELETE CASCADE,
  "name"   text DEFAULT '紙切れ',
  "power"  int  DEFAULT 0,
  "skill_category"  text DEFAULT '',
  "skill_name"      text DEFAULT '',
  "skill2_category" text DEFAULT '',
  "skill2_name"     text DEFAULT ''
);

CREATE TABLE "player_command_record" (
  "player_id" text REFERENCES "player" ("id") ON DELETE CASCADE,
  "command_name"  text NOT NULL,
  "execute_count" int DEFAULT 0,
  PRIMARY KEY("player_id", "command_name")
  -- my $model = Jikokku::Model::Player::Command->new(id => 'plyaer_id');
  -- $model->get();
  -- $model->execute_count('command_name');
  -- = $player->command->execute_count('command_name');
);

CREATE TABLE "player_battle_record" (
  "player_id" text PRIMARY KEY REFERENCES "player" ("id") ON DELETE CASCADE,
  "attack_win"   int DEFAULT 0,
  "attack_lose"  int DEFAULT 0,
  "guard_win"    int DEFAULT 0,
  "guard_lose"   int DEFAULT 0,
  "draw"         int DEFAULT 0,
  "kill_people"  int DEFAULT 0,
  "die_people"   int DEFAULT 0,
  "conquer_town" int DEFAULT 0,
  "attack_town"  int DEFAULT 0,
  "wall_destroy" int DEFAULT 0
);

CREATE TABLE "player_soldier" (
  "player_id" text PRIMARY KEY REFERENCES "player" ("id") ON DELETE CASCADE,
  "name"      text DEFAULT '雑兵',
  -- Rowクラス側では兵士オブジェクトを委譲する
  "people"    int DEFAULT 0,
  "training"  int DEFAULT 0
);

CREATE TABLE "player_skill" (
  "player_id" text REFERENCES "player" ("id") ON DELETE CASCADE,
  "skill_category"  text NOT NULL,
  "skill_name"      text NOT NULL,
  PRIMARY KEY("player_id", "skill_category", "skill_name")
);

CREATE TABLE "player_letter" (
  "player_id" text REFERENCES "player" ("id") ON DELETE CASCADE,
  "id"        serial PRIMARY KEY,
  "sender_name" text NOT NULL,
  "sender_icon" int NOT NULL,
  "sender_town_name"    text NOT NULL,
  "sender_country_name" text NOT NULL,
  "receiver_name"       text NOT NULL,
  "message" text NOT NULL,
  "time"    text NOT NULL
);

CREATE TABLE "player_invite" (
  "player_id" text REFERENCES "player" ("id") ON DELETE CASCADE,
  "id"        serial PRIMARY KEY,
  "sender_name" text NOT NULL,
  "sender_id"   text NOT NULL,
  "sender_icon" int NOT NULL,
  "sender_town_name"    text NOT NULL,
  "sender_country_name" text NOT NULL,
  "receiver_name"       text NOT NULL,
  "message" text NOT NULL,
  "time"    text NOT NULL
);


-- 都市城の守備
CREATE TABLE "town_guards" (
  "player_id" text PRIMARY KEY REFERENCES "player" ("id") ON DELETE CASCADE,
  "town_name" text REFERENCES "town" ("name") ON DELETE CASCADE,
  "order"     int DEFAULT 0,
  UNIQUE("town_name", "order")
);


-- 国役職一覧
CREATE TABLE "country_position" (
  "country_name" text PRIMARY KEY REFERENCES "country" ("name") ON DELETE CASCADE,
  "king_id"      text UNIQUE REFERENCES "player" ("id") ON DELETE SET NULL,
  "premier_id"          text REFERENCES "player" ("id") ON DELETE SET NULL,
  "strategist_id"       text REFERENCES "player" ("id") ON DELETE SET NULL,
  "great_general_id"    text REFERENCES "player" ("id") ON DELETE SET NULL,
  "cavalry_general_id"  text REFERENCES "player" ("id") ON DELETE SET NULL,
  "guard_general_id"    text REFERENCES "player" ("id") ON DELETE SET NULL,
  "archery_general_id"  text REFERENCES "player" ("id") ON DELETE SET NULL,
  -- infantry = 歩兵
  "infantry_general_id" text REFERENCES "player" ("id") ON DELETE SET NULL
);


-- 部隊関連テーブル
CREATE TABLE "unit" (
  "id" text PRIMARY KEY REFERENCES "player" ("id") ON DELETE CASCADE,
  "name" text,
  "country_name" text REFERENCES "country" ("name") ON DELETE CASCADE,
  "message" text DEFAULT '',
  "join_permit" int DEFAULT 1,
  "auto_gather" int DEFAULT 0,
  UNIQUE("name", "country_name")
);

CREATE TABLE "unit_letter" (
  "unit_id" text REFERENCES "unit" ("id") ON DELETE CASCADE,
  "id"        serial PRIMARY KEY,
  "sender_name" text NOT NULL,
  "sender_icon"  int NOT NULL,
  "sender_town_name"    text NOT NULL,
  "sender_country_name" text NOT NULL,
  "receiver_name"       text NOT NULL,
  "message" text NOT NULL,
  "time"    text NOT NULL
);


-- 運営からのお知らせ
CREATE TABLE "announce" (
  "id" serial PRIMARY KEY,
  "date"    text NOT NULL, 
  "message" text NOT NULL
);


-- 専用BBSスレッド
CREATE TABLE "forum_thread" (
  "id" serial PRIMARY KEY,
  "title"   text NOT NULL,
  "name"    text NOT NULL,
  "message" text NOT NULL,
  "icon" int NOT NULL,
  "time" text NOT NULL
);

-- 専用BBS返信
CREATE TABLE "forum_reply" (
  "thread_id" int REFERENCES "forum_thread" ("id") ON DELETE CASCADE,
  "id"        serial PRIMARY KEY,
  "name"    text NOT NULL,
  "message" text NOT NULL,
  "icon" int NOT NULL,
  "time" text NOT NULL
);


-- 雑談BBS or チャット
CREATE TABLE "idle_talk" (
  "id"        serial PRIMARY KEY,
  "name" text NOT NULL,
  "icon"  int NOT NULL,
  "message" text NOT NULL,
  "time"    text NOT NULL
);


-- アイコンアップローダ
CREATE TABLE "icon_uploader" (
  "id"   serial PRIMARY KEY,
  "tag"  text DEFAULT '',
  "time" text NOT NULL
);

