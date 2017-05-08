--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.1
-- Dumped by pg_dump version 9.6.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: partman; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA partman;


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pg_partman; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_partman WITH SCHEMA partman;


--
-- Name: EXTENSION pg_partman; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_partman IS 'Extension to manage partitioned tables by time or ID';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = public, pg_catalog;

--
-- Name: impressions_part_trig_func(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION impressions_part_trig_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
            DECLARE
            v_count                 int;
            v_partition_name        text;
            v_partition_timestamp   timestamptz;
        BEGIN 
        IF TG_OP = 'INSERT' THEN 
            v_partition_timestamp := date_trunc('day', NEW.created_at);
            IF NEW.created_at >= '2017-01-18 00:00:00+00' AND NEW.created_at < '2017-01-19 00:00:00+00' THEN 
            INSERT INTO public.impressions_p2017_01_18 VALUES (NEW.*) ; 
            ELSIF NEW.created_at >= '2017-01-17 00:00:00+00' AND NEW.created_at < '2017-01-18 00:00:00+00' THEN 
                INSERT INTO public.impressions_p2017_01_17 VALUES (NEW.*) ; 
            ELSIF NEW.created_at >= '2017-01-19 00:00:00+00' AND NEW.created_at < '2017-01-20 00:00:00+00' THEN 
                INSERT INTO public.impressions_p2017_01_19 VALUES (NEW.*) ;
            ELSIF NEW.created_at >= '2017-01-16 00:00:00+00' AND NEW.created_at < '2017-01-17 00:00:00+00' THEN 
                INSERT INTO public.impressions_p2017_01_16 VALUES (NEW.*) ; 
            ELSIF NEW.created_at >= '2017-01-20 00:00:00+00' AND NEW.created_at < '2017-01-21 00:00:00+00' THEN 
                INSERT INTO public.impressions_p2017_01_20 VALUES (NEW.*) ;
            ELSIF NEW.created_at >= '2017-01-15 00:00:00+00' AND NEW.created_at < '2017-01-16 00:00:00+00' THEN 
                INSERT INTO public.impressions_p2017_01_15 VALUES (NEW.*) ; 
            ELSIF NEW.created_at >= '2017-01-21 00:00:00+00' AND NEW.created_at < '2017-01-22 00:00:00+00' THEN 
                INSERT INTO public.impressions_p2017_01_21 VALUES (NEW.*) ;
            ELSIF NEW.created_at >= '2017-01-14 00:00:00+00' AND NEW.created_at < '2017-01-15 00:00:00+00' THEN 
                INSERT INTO public.impressions_p2017_01_14 VALUES (NEW.*) ; 
            ELSIF NEW.created_at >= '2017-01-22 00:00:00+00' AND NEW.created_at < '2017-01-23 00:00:00+00' THEN 
                INSERT INTO public.impressions_p2017_01_22 VALUES (NEW.*) ;
            ELSE
                v_partition_name := partman.check_name_length('impressions', to_char(v_partition_timestamp, 'YYYY_MM_DD'), TRUE);
                SELECT count(*) INTO v_count FROM pg_catalog.pg_tables WHERE schemaname = 'public'::name AND tablename = v_partition_name::name;
                IF v_count > 0 THEN 
                    EXECUTE format('INSERT INTO %I.%I VALUES($1.*) ', 'public', v_partition_name) USING NEW;
                ELSE
                    RETURN NEW;
                END IF;
            END IF;
        END IF;
        RETURN NULL;
        END $_$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: impressions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE impressions (
    viewer_id character varying,
    post_id character varying NOT NULL,
    author_id character varying NOT NULL,
    created_at timestamp(4) without time zone NOT NULL,
    stream_kind character varying,
    stream_id character varying,
    uuid uuid
);


--
-- Name: impressions_p2017_01_14; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE impressions_p2017_01_14 (
    viewer_id character varying,
    post_id character varying,
    author_id character varying,
    created_at timestamp(4) without time zone,
    CONSTRAINT impressions_p2017_01_14_partition_check CHECK (((created_at >= '2017-01-14 00:00:00'::timestamp without time zone) AND (created_at < '2017-01-15 00:00:00'::timestamp without time zone)))
)
INHERITS (impressions);


--
-- Name: impressions_p2017_01_15; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE impressions_p2017_01_15 (
    viewer_id character varying,
    post_id character varying,
    author_id character varying,
    created_at timestamp(4) without time zone,
    CONSTRAINT impressions_p2017_01_15_partition_check CHECK (((created_at >= '2017-01-15 00:00:00'::timestamp without time zone) AND (created_at < '2017-01-16 00:00:00'::timestamp without time zone)))
)
INHERITS (impressions);


--
-- Name: impressions_p2017_01_16; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE impressions_p2017_01_16 (
    viewer_id character varying,
    post_id character varying,
    author_id character varying,
    created_at timestamp(4) without time zone,
    CONSTRAINT impressions_p2017_01_16_partition_check CHECK (((created_at >= '2017-01-16 00:00:00'::timestamp without time zone) AND (created_at < '2017-01-17 00:00:00'::timestamp without time zone)))
)
INHERITS (impressions);


--
-- Name: impressions_p2017_01_17; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE impressions_p2017_01_17 (
    viewer_id character varying,
    post_id character varying,
    author_id character varying,
    created_at timestamp(4) without time zone,
    CONSTRAINT impressions_p2017_01_17_partition_check CHECK (((created_at >= '2017-01-17 00:00:00'::timestamp without time zone) AND (created_at < '2017-01-18 00:00:00'::timestamp without time zone)))
)
INHERITS (impressions);


--
-- Name: impressions_p2017_01_18; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE impressions_p2017_01_18 (
    viewer_id character varying,
    post_id character varying,
    author_id character varying,
    created_at timestamp(4) without time zone,
    CONSTRAINT impressions_p2017_01_18_partition_check CHECK (((created_at >= '2017-01-18 00:00:00'::timestamp without time zone) AND (created_at < '2017-01-19 00:00:00'::timestamp without time zone)))
)
INHERITS (impressions);


--
-- Name: impressions_p2017_01_19; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE impressions_p2017_01_19 (
    viewer_id character varying,
    post_id character varying,
    author_id character varying,
    created_at timestamp(4) without time zone,
    CONSTRAINT impressions_p2017_01_19_partition_check CHECK (((created_at >= '2017-01-19 00:00:00'::timestamp without time zone) AND (created_at < '2017-01-20 00:00:00'::timestamp without time zone)))
)
INHERITS (impressions);


--
-- Name: impressions_p2017_01_20; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE impressions_p2017_01_20 (
    viewer_id character varying,
    post_id character varying,
    author_id character varying,
    created_at timestamp(4) without time zone,
    CONSTRAINT impressions_p2017_01_20_partition_check CHECK (((created_at >= '2017-01-20 00:00:00'::timestamp without time zone) AND (created_at < '2017-01-21 00:00:00'::timestamp without time zone)))
)
INHERITS (impressions);


--
-- Name: impressions_p2017_01_21; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE impressions_p2017_01_21 (
    viewer_id character varying,
    post_id character varying,
    author_id character varying,
    created_at timestamp(4) without time zone,
    CONSTRAINT impressions_p2017_01_21_partition_check CHECK (((created_at >= '2017-01-21 00:00:00'::timestamp without time zone) AND (created_at < '2017-01-22 00:00:00'::timestamp without time zone)))
)
INHERITS (impressions);


--
-- Name: impressions_p2017_01_22; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE impressions_p2017_01_22 (
    viewer_id character varying,
    post_id character varying,
    author_id character varying,
    created_at timestamp(4) without time zone,
    CONSTRAINT impressions_p2017_01_22_partition_check CHECK (((created_at >= '2017-01-22 00:00:00'::timestamp without time zone) AND (created_at < '2017-01-23 00:00:00'::timestamp without time zone)))
)
INHERITS (impressions);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: impressions_p2017_01_14_created_at_author_id_post_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX impressions_p2017_01_14_created_at_author_id_post_id_idx ON impressions_p2017_01_14 USING btree (created_at, author_id, post_id);


--
-- Name: impressions_p2017_01_15_created_at_author_id_post_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX impressions_p2017_01_15_created_at_author_id_post_id_idx ON impressions_p2017_01_15 USING btree (created_at, author_id, post_id);


--
-- Name: impressions_p2017_01_16_created_at_author_id_post_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX impressions_p2017_01_16_created_at_author_id_post_id_idx ON impressions_p2017_01_16 USING btree (created_at, author_id, post_id);


--
-- Name: impressions_p2017_01_17_created_at_author_id_post_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX impressions_p2017_01_17_created_at_author_id_post_id_idx ON impressions_p2017_01_17 USING btree (created_at, author_id, post_id);


--
-- Name: impressions_p2017_01_18_created_at_author_id_post_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX impressions_p2017_01_18_created_at_author_id_post_id_idx ON impressions_p2017_01_18 USING btree (created_at, author_id, post_id);


--
-- Name: impressions_p2017_01_19_created_at_author_id_post_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX impressions_p2017_01_19_created_at_author_id_post_id_idx ON impressions_p2017_01_19 USING btree (created_at, author_id, post_id);


--
-- Name: impressions_p2017_01_20_created_at_author_id_post_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX impressions_p2017_01_20_created_at_author_id_post_id_idx ON impressions_p2017_01_20 USING btree (created_at, author_id, post_id);


--
-- Name: impressions_p2017_01_21_created_at_author_id_post_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX impressions_p2017_01_21_created_at_author_id_post_id_idx ON impressions_p2017_01_21 USING btree (created_at, author_id, post_id);


--
-- Name: impressions_p2017_01_22_created_at_author_id_post_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX impressions_p2017_01_22_created_at_author_id_post_id_idx ON impressions_p2017_01_22 USING btree (created_at, author_id, post_id);


--
-- Name: index_impressions_on_created_at_and_author_id_and_post_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_impressions_on_created_at_and_author_id_and_post_id ON impressions USING btree (created_at, author_id, post_id);


--
-- Name: index_impressions_on_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_impressions_on_uuid ON impressions USING btree (uuid) WHERE (uuid IS NULL);


--
-- Name: index_impressions_on_viewer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_impressions_on_viewer_id ON impressions USING btree (viewer_id);


--
-- Name: impressions impressions_part_trig; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER impressions_part_trig BEFORE INSERT ON impressions FOR EACH ROW EXECUTE PROCEDURE impressions_part_trig_func();


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20161017153308'), ('20161101113557'), ('20161220042635'), ('20161220042637'), ('20161220045344'), ('20161220145823'), ('20161220154502'), ('20170103213513'), ('20170118203315'), ('20170221035451'), ('20170508174610'), ('20170508195650');


