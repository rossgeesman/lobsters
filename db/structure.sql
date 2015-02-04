--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comments (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    short_id character varying(10) DEFAULT ''::character varying NOT NULL,
    story_id integer NOT NULL,
    user_id integer NOT NULL,
    parent_comment_id integer,
    thread_id integer,
    comment text NOT NULL,
    upvotes integer DEFAULT 0 NOT NULL,
    downvotes integer DEFAULT 0 NOT NULL,
    confidence numeric(20,19) DEFAULT 0.0 NOT NULL,
    markeddown_comment text,
    is_deleted boolean DEFAULT false,
    is_moderated boolean DEFAULT false,
    is_from_email boolean DEFAULT false,
    hat_id integer
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: hats; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hats (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    user_id integer,
    granted_by_user_id integer,
    hat character varying(255),
    link character varying(255)
);


--
-- Name: hats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE hats_id_seq OWNED BY hats.id;


--
-- Name: invitation_requests; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE invitation_requests (
    id integer NOT NULL,
    code character varying(255),
    is_verified boolean DEFAULT false,
    email character varying(255),
    name character varying(255),
    memo text,
    ip_address character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: invitation_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invitation_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invitation_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invitation_requests_id_seq OWNED BY invitation_requests.id;


--
-- Name: invitations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE invitations (
    id integer NOT NULL,
    user_id integer,
    email character varying(255),
    code character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    memo text
);


--
-- Name: invitations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invitations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invitations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invitations_id_seq OWNED BY invitations.id;


--
-- Name: keystores; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE keystores (
    key character varying(50) DEFAULT ''::character varying NOT NULL,
    value bigint
);


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE messages (
    id integer NOT NULL,
    created_at timestamp without time zone,
    author_user_id integer,
    recipient_user_id integer,
    has_been_read boolean DEFAULT false,
    subject character varying(100),
    body text,
    short_id character varying(30),
    deleted_by_author boolean DEFAULT false,
    deleted_by_recipient boolean DEFAULT false
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE messages_id_seq OWNED BY messages.id;


--
-- Name: moderations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE moderations (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    moderator_user_id integer,
    story_id integer,
    comment_id integer,
    user_id integer,
    action text,
    reason text
);


--
-- Name: moderations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE moderations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: moderations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE moderations_id_seq OWNED BY moderations.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: stories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE stories (
    id integer NOT NULL,
    created_at timestamp without time zone,
    user_id integer,
    url character varying(250) DEFAULT ''::character varying,
    title character varying(150) DEFAULT ''::character varying NOT NULL,
    description text,
    short_id character varying(6) DEFAULT ''::character varying NOT NULL,
    is_expired smallint DEFAULT 0 NOT NULL,
    upvotes integer DEFAULT 0 NOT NULL,
    downvotes integer DEFAULT 0 NOT NULL,
    is_moderated smallint DEFAULT 0 NOT NULL,
    hotness numeric(20,10) DEFAULT 0.0 NOT NULL,
    markeddown_description text,
    story_cache text,
    comments_count integer DEFAULT 0 NOT NULL,
    merged_story_id integer,
    unavailable_at timestamp without time zone
);


--
-- Name: stories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stories_id_seq OWNED BY stories.id;


--
-- Name: tag_filters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tag_filters (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    tag_id integer
);


--
-- Name: tag_filters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tag_filters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tag_filters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tag_filters_id_seq OWNED BY tag_filters.id;


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taggings (
    id integer NOT NULL,
    story_id integer NOT NULL,
    tag_id integer NOT NULL
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taggings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taggings_id_seq OWNED BY taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tags (
    id integer NOT NULL,
    tag character varying(25) DEFAULT ''::character varying NOT NULL,
    description character varying(100),
    privileged boolean DEFAULT false,
    is_media boolean DEFAULT false,
    inactive boolean DEFAULT false,
    hotness_mod integer DEFAULT 0
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    username character varying(50),
    email character varying(100),
    password_digest character varying(75),
    created_at timestamp without time zone,
    email_notifications boolean DEFAULT false,
    is_admin boolean DEFAULT false,
    password_reset_token character varying(75),
    session_token character varying(75) DEFAULT ''::character varying NOT NULL,
    about text,
    invited_by_user_id integer,
    email_replies boolean DEFAULT false,
    pushover_replies boolean DEFAULT false,
    pushover_user_key character varying(255),
    pushover_device character varying(255),
    email_messages boolean DEFAULT true,
    pushover_messages boolean DEFAULT true,
    is_moderator boolean DEFAULT false,
    email_mentions boolean DEFAULT false,
    pushover_mentions boolean DEFAULT false,
    rss_token character varying(75),
    mailing_list_token character varying(75),
    mailing_list_mode integer DEFAULT 0,
    karma integer DEFAULT 0 NOT NULL,
    banned_at timestamp without time zone,
    banned_by_user_id integer,
    banned_reason character varying(200),
    deleted_at timestamp without time zone,
    pushover_sound character varying(255)
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: votes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE votes (
    id integer NOT NULL,
    user_id integer NOT NULL,
    story_id integer NOT NULL,
    comment_id integer,
    vote smallint NOT NULL,
    reason character varying(1)
);


--
-- Name: votes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE votes_id_seq OWNED BY votes.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY hats ALTER COLUMN id SET DEFAULT nextval('hats_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY invitation_requests ALTER COLUMN id SET DEFAULT nextval('invitation_requests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY invitations ALTER COLUMN id SET DEFAULT nextval('invitations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages ALTER COLUMN id SET DEFAULT nextval('messages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY moderations ALTER COLUMN id SET DEFAULT nextval('moderations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stories ALTER COLUMN id SET DEFAULT nextval('stories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tag_filters ALTER COLUMN id SET DEFAULT nextval('tag_filters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggings ALTER COLUMN id SET DEFAULT nextval('taggings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY votes ALTER COLUMN id SET DEFAULT nextval('votes_id_seq'::regclass);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: hats_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hats
    ADD CONSTRAINT hats_pkey PRIMARY KEY (id);


--
-- Name: invitation_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invitation_requests
    ADD CONSTRAINT invitation_requests_pkey PRIMARY KEY (id);


--
-- Name: invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invitations
    ADD CONSTRAINT invitations_pkey PRIMARY KEY (id);


--
-- Name: messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: moderations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY moderations
    ADD CONSTRAINT moderations_pkey PRIMARY KEY (id);


--
-- Name: stories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stories
    ADD CONSTRAINT stories_pkey PRIMARY KEY (id);


--
-- Name: tag_filters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tag_filters
    ADD CONSTRAINT tag_filters_pkey PRIMARY KEY (id);


--
-- Name: taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY votes
    ADD CONSTRAINT votes_pkey PRIMARY KEY (id);


--
-- Name: confidence_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX confidence_idx ON comments USING btree (confidence);


--
-- Name: hotness_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX hotness_idx ON stories USING btree (hotness);


--
-- Name: index_stories_on_merged_story_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_stories_on_merged_story_id ON stories USING btree (merged_story_id);


--
-- Name: is_idxes; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX is_idxes ON stories USING btree (is_expired, is_moderated);


--
-- Name: key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX key ON keystores USING btree (key);


--
-- Name: mailing_list_enabled; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX mailing_list_enabled ON users USING btree (mailing_list_mode);


--
-- Name: mailing_list_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX mailing_list_token ON users USING btree (mailing_list_token);


--
-- Name: password_reset_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX password_reset_token ON users USING btree (password_reset_token);


--
-- Name: random_hash; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX random_hash ON messages USING btree (short_id);


--
-- Name: rss_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX rss_token ON users USING btree (rss_token);


--
-- Name: session_hash; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX session_hash ON users USING btree (session_token);


--
-- Name: short_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX short_id ON comments USING btree (short_id);


--
-- Name: story_id_short_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX story_id_short_id ON comments USING btree (story_id, short_id);


--
-- Name: story_id_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX story_id_tag_id ON taggings USING btree (story_id, tag_id);


--
-- Name: story_title_gin_eng_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX story_title_gin_eng_idx ON stories USING gin (to_tsvector('english'::regconfig, (title)::text));


--
-- Name: tag; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX tag ON tags USING btree (tag);


--
-- Name: thread_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX thread_id ON comments USING btree (thread_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: unique_short_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_short_id ON stories USING btree (short_id);


--
-- Name: url; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX url ON stories USING btree (url);


--
-- Name: user_id_comment_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX user_id_comment_id ON votes USING btree (user_id, comment_id);


--
-- Name: user_id_story_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX user_id_story_id ON votes USING btree (user_id, story_id);


--
-- Name: user_tag_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX user_tag_idx ON tag_filters USING btree (user_id, tag_id);


--
-- Name: username; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX username ON users USING btree (username);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20120701154453');

INSERT INTO schema_migrations (version) VALUES ('20120701160006');

INSERT INTO schema_migrations (version) VALUES ('20120701181319');

INSERT INTO schema_migrations (version) VALUES ('20120703184957');

INSERT INTO schema_migrations (version) VALUES ('20120704004020');

INSERT INTO schema_migrations (version) VALUES ('20120704013019');

INSERT INTO schema_migrations (version) VALUES ('20120704025956');

INSERT INTO schema_migrations (version) VALUES ('20120705145520');

INSERT INTO schema_migrations (version) VALUES ('20120706221602');

INSERT INTO schema_migrations (version) VALUES ('20120712174445');

INSERT INTO schema_migrations (version) VALUES ('20120816203248');

INSERT INTO schema_migrations (version) VALUES ('20120902143549');

INSERT INTO schema_migrations (version) VALUES ('20120906183346');

INSERT INTO schema_migrations (version) VALUES ('20120910172514');

INSERT INTO schema_migrations (version) VALUES ('20120918152116');

INSERT INTO schema_migrations (version) VALUES ('20120919195401');

INSERT INTO schema_migrations (version) VALUES ('20121004153529');

INSERT INTO schema_migrations (version) VALUES ('20121112165212');

INSERT INTO schema_migrations (version) VALUES ('20130526164230');

INSERT INTO schema_migrations (version) VALUES ('20130622021035');

INSERT INTO schema_migrations (version) VALUES ('20131018201413');

INSERT INTO schema_migrations (version) VALUES ('20131228175805');

INSERT INTO schema_migrations (version) VALUES ('20140101202252');

INSERT INTO schema_migrations (version) VALUES ('20140106205200');

INSERT INTO schema_migrations (version) VALUES ('20140109034338');

INSERT INTO schema_migrations (version) VALUES ('20140112192936');

INSERT INTO schema_migrations (version) VALUES ('20140113153413');

INSERT INTO schema_migrations (version) VALUES ('20140121063641');

INSERT INTO schema_migrations (version) VALUES ('20140219183804');

INSERT INTO schema_migrations (version) VALUES ('20140221164400');

INSERT INTO schema_migrations (version) VALUES ('20140408160306');

INSERT INTO schema_migrations (version) VALUES ('20140701153554');

INSERT INTO schema_migrations (version) VALUES ('20140804005415');

INSERT INTO schema_migrations (version) VALUES ('20140825225915');

INSERT INTO schema_migrations (version) VALUES ('20140901013149');

INSERT INTO schema_migrations (version) VALUES ('20141114184921');

INSERT INTO schema_migrations (version) VALUES ('20150106195555');

INSERT INTO schema_migrations (version) VALUES ('20150131164151');

INSERT INTO schema_migrations (version) VALUES ('20150131174947');

