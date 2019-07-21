CREATE USER wmlclient with login password 'wmlclient';

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.9 (Ubuntu 10.9-1.pgdg18.04+1)
-- Dumped by pg_dump version 10.9 (Ubuntu 10.9-1.pgdg18.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: odm; Type: DATABASE; Schema: -; Owner: wmclient
--

CREATE DATABASE odm WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';


ALTER DATABASE odm OWNER TO wmlclient;

\connect odm

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: wmclient
--

CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO wmlclient;

--
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: wmclient
--

CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO wmlclient;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: wmclient
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO wmlclient;

--
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: wmclient
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: address_standardizer; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS address_standardizer WITH SCHEMA public;


--
-- Name: EXTENSION address_standardizer; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION address_standardizer IS 'Used to parse an address into constituent elements. Generally used to support geocoding address normalization step.';


--
-- Name: address_standardizer_data_us; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS address_standardizer_data_us WITH SCHEMA public;


--
-- Name: EXTENSION address_standardizer_data_us; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION address_standardizer_data_us IS 'Address Standardizer US dataset example';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: postgis_tiger_geocoder; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder WITH SCHEMA tiger;


--
-- Name: EXTENSION postgis_tiger_geocoder; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_tiger_geocoder IS 'PostGIS tiger geocoder and reverse geocoder';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


--
-- Name: trg_geom_default(); Type: FUNCTION; Schema: public; Owner: wmclient
--

CREATE FUNCTION public.trg_geom_default() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

NEW."Geometry" := st_setsrid(st_point(NEW."Longitude",NEW."Latitude"),4326);

RETURN NEW;

END
$$;


ALTER FUNCTION public.trg_geom_default() OWNER TO wmlclient;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: Categories; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."Categories" (
    "VariableID" integer NOT NULL,
    "DataValue" real NOT NULL,
    "CategoryDescription" text NOT NULL
);


ALTER TABLE public."Categories" OWNER TO wmlclient;

--
-- Name: CensorCodeCV; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."CensorCodeCV" (
    "Term" character varying(50) NOT NULL,
    "Definition" text
);


ALTER TABLE public."CensorCodeCV" OWNER TO wmlclient;

--
-- Name: DataTypeCV; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."DataTypeCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."DataTypeCV" OWNER TO wmlclient;

--
-- Name: DataValues; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."DataValues" (
    "ValueID" integer NOT NULL,
    "DataValue" real NOT NULL,
    "ValueAccuracy" real,
    "LocalDateTime" timestamp without time zone NOT NULL,
    "UTCOffset" real NOT NULL,
    "DateTimeUTC" timestamp without time zone NOT NULL,
    "SiteID" integer NOT NULL,
    "VariableID" integer NOT NULL,
    "OffsetValue" real,
    "OffsetTypeID" integer,
    "CensorCode" character varying(50) DEFAULT 'nc'::character varying NOT NULL,
    "QualifierID" integer,
    "MethodID" integer DEFAULT 0,
    "SourceID" integer,
    "SampleID" integer,
    "DerivedFromID" integer,
    "QualityControlLevelID" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."DataValues" OWNER TO wmlclient;

--
-- Name: DataValues_ValueID_seq; Type: SEQUENCE; Schema: public; Owner: wmclient
--

CREATE SEQUENCE public."DataValues_ValueID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."DataValues_ValueID_seq" OWNER TO wmlclient;

--
-- Name: DataValues_ValueID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmclient
--

ALTER SEQUENCE public."DataValues_ValueID_seq" OWNED BY public."DataValues"."ValueID";


--
-- Name: DerivedFrom; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."DerivedFrom" (
    "DerivedFromID" integer NOT NULL,
    "ValueID" integer NOT NULL
);


ALTER TABLE public."DerivedFrom" OWNER TO wmlclient;

--
-- Name: FeatureTypeCV; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."FeatureTypeCV" (
    "FeatureTypeID" integer NOT NULL,
    "FeatureTypeName" character varying NOT NULL,
    "Description" character varying
);


ALTER TABLE public."FeatureTypeCV" OWNER TO wmlclient;

--
-- Name: FeatureTypeCV_FeatureTypeID_seq; Type: SEQUENCE; Schema: public; Owner: wmclient
--

CREATE SEQUENCE public."FeatureTypeCV_FeatureTypeID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."FeatureTypeCV_FeatureTypeID_seq" OWNER TO wmlclient;

--
-- Name: FeatureTypeCV_FeatureTypeID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmclient
--

ALTER SEQUENCE public."FeatureTypeCV_FeatureTypeID_seq" OWNED BY public."FeatureTypeCV"."FeatureTypeID";


--
-- Name: GeneralCategoryCV; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."GeneralCategoryCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."GeneralCategoryCV" OWNER TO wmlclient;

--
-- Name: GroupDescriptions; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."GroupDescriptions" (
    "GroupID" integer NOT NULL,
    "GroupDescription" text
);


ALTER TABLE public."GroupDescriptions" OWNER TO wmlclient;

--
-- Name: GroupDescriptions_GroupID_seq; Type: SEQUENCE; Schema: public; Owner: wmclient
--

CREATE SEQUENCE public."GroupDescriptions_GroupID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."GroupDescriptions_GroupID_seq" OWNER TO wmlclient;

--
-- Name: GroupDescriptions_GroupID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmclient
--

ALTER SEQUENCE public."GroupDescriptions_GroupID_seq" OWNED BY public."GroupDescriptions"."GroupID";


--
-- Name: Groups; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."Groups" (
    "GroupID" integer NOT NULL,
    "ValueID" integer NOT NULL
);


ALTER TABLE public."Groups" OWNER TO wmlclient;

--
-- Name: ISOMetadata; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."ISOMetadata" (
    "MetadataID" integer NOT NULL,
    "TopicCategory" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "Title" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "Abstract" text NOT NULL,
    "ProfileVersion" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "MetadataLink" text
);


ALTER TABLE public."ISOMetadata" OWNER TO wmlclient;

--
-- Name: ISOMetadata_MetadataID_seq; Type: SEQUENCE; Schema: public; Owner: wmclient
--

CREATE SEQUENCE public."ISOMetadata_MetadataID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."ISOMetadata_MetadataID_seq" OWNER TO wmlclient;

--
-- Name: ISOMetadata_MetadataID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmclient
--

ALTER SEQUENCE public."ISOMetadata_MetadataID_seq" OWNED BY public."ISOMetadata"."MetadataID";


--
-- Name: LabMethods; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."LabMethods" (
    "LabMethodID" integer NOT NULL,
    "LabName" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "LabOrganization" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "LabMethodName" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "LabMethodDescription" text NOT NULL,
    "LabMethodLink" text
);


ALTER TABLE public."LabMethods" OWNER TO wmlclient;

--
-- Name: LabMethods_LabMethodID_seq; Type: SEQUENCE; Schema: public; Owner: wmclient
--

CREATE SEQUENCE public."LabMethods_LabMethodID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."LabMethods_LabMethodID_seq" OWNER TO wmlclient;

--
-- Name: LabMethods_LabMethodID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmclient
--

ALTER SEQUENCE public."LabMethods_LabMethodID_seq" OWNED BY public."LabMethods"."LabMethodID";


--
-- Name: Methods; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."Methods" (
    "MethodID" integer NOT NULL,
    "MethodDescription" text NOT NULL,
    "MethodLink" text,
    "MethodCode" character varying(255) NOT NULL
);


ALTER TABLE public."Methods" OWNER TO wmlclient;

--
-- Name: Methods_MethodID_seq; Type: SEQUENCE; Schema: public; Owner: wmclient
--

CREATE SEQUENCE public."Methods_MethodID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Methods_MethodID_seq" OWNER TO wmlclient;

--
-- Name: Methods_MethodID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmclient
--

ALTER SEQUENCE public."Methods_MethodID_seq" OWNED BY public."Methods"."MethodID";


--
-- Name: ODMVersion; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."ODMVersion" (
    "VersionNumber" character varying(50) NOT NULL
);


ALTER TABLE public."ODMVersion" OWNER TO wmlclient;

--
-- Name: OffsetTypes; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."OffsetTypes" (
    "OffsetTypeID" integer NOT NULL,
    "OffsetUnitsID" integer NOT NULL,
    "OffsetDescription" text NOT NULL
);


ALTER TABLE public."OffsetTypes" OWNER TO wmlclient;

--
-- Name: OffsetTypes_OffsetTypeID_seq; Type: SEQUENCE; Schema: public; Owner: wmclient
--

CREATE SEQUENCE public."OffsetTypes_OffsetTypeID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."OffsetTypes_OffsetTypeID_seq" OWNER TO wmlclient;

--
-- Name: OffsetTypes_OffsetTypeID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmclient
--

ALTER SEQUENCE public."OffsetTypes_OffsetTypeID_seq" OWNED BY public."OffsetTypes"."OffsetTypeID";


--
-- Name: Qualifiers; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."Qualifiers" (
    "QualifierID" integer NOT NULL,
    "QualifierCode" character varying(50) DEFAULT NULL::character varying,
    "QualifierDescription" text NOT NULL
);


ALTER TABLE public."Qualifiers" OWNER TO wmlclient;

--
-- Name: Qualifiers_QualifierID_seq; Type: SEQUENCE; Schema: public; Owner: wmclient
--

CREATE SEQUENCE public."Qualifiers_QualifierID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Qualifiers_QualifierID_seq" OWNER TO wmlclient;

--
-- Name: Qualifiers_QualifierID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmclient
--

ALTER SEQUENCE public."Qualifiers_QualifierID_seq" OWNED BY public."Qualifiers"."QualifierID";


--
-- Name: QualityControlLevels; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."QualityControlLevels" (
    "QualityControlLevelID" integer NOT NULL,
    "QualityControlLevelCode" character varying(50) NOT NULL,
    "Definition" character varying(255) NOT NULL,
    "Explanation" text NOT NULL
);


ALTER TABLE public."QualityControlLevels" OWNER TO wmlclient;

--
-- Name: QualityControlLevels_QualityControlLevelID_seq; Type: SEQUENCE; Schema: public; Owner: wmclient
--

CREATE SEQUENCE public."QualityControlLevels_QualityControlLevelID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."QualityControlLevels_QualityControlLevelID_seq" OWNER TO wmlclient;

--
-- Name: QualityControlLevels_QualityControlLevelID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmclient
--

ALTER SEQUENCE public."QualityControlLevels_QualityControlLevelID_seq" OWNED BY public."QualityControlLevels"."QualityControlLevelID";


--
-- Name: SampleMediumCV; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."SampleMediumCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."SampleMediumCV" OWNER TO wmlclient;

--
-- Name: SampleTypeCV; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."SampleTypeCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."SampleTypeCV" OWNER TO wmlclient;

--
-- Name: Samples; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."Samples" (
    "SampleID" integer NOT NULL,
    "SampleType" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "LabSampleCode" character varying(50) NOT NULL,
    "LabMethodID" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."Samples" OWNER TO wmlclient;

--
-- Name: Samples_SampleID_seq; Type: SEQUENCE; Schema: public; Owner: wmclient
--

CREATE SEQUENCE public."Samples_SampleID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Samples_SampleID_seq" OWNER TO wmlclient;

--
-- Name: Samples_SampleID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmclient
--

ALTER SEQUENCE public."Samples_SampleID_seq" OWNED BY public."Samples"."SampleID";


--
-- Name: SeriesCatalog; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."SeriesCatalog" (
    "SeriesID" integer NOT NULL,
    "SiteID" integer,
    "SiteCode" character varying(50) DEFAULT NULL::character varying,
    "SiteName" character varying(255) DEFAULT NULL::character varying,
    "SiteType" character varying(255) DEFAULT NULL::character varying,
    "VariableID" integer,
    "VariableCode" character varying(50) DEFAULT NULL::character varying,
    "VariableName" character varying(255) DEFAULT NULL::character varying,
    "Speciation" character varying(255) DEFAULT NULL::character varying,
    "VariableUnitsID" integer,
    "VariableUnitsName" character varying(255) DEFAULT NULL::character varying,
    "SampleMedium" character varying(255) DEFAULT NULL::character varying,
    "ValueType" character varying(255) DEFAULT NULL::character varying,
    "TimeSupport" real,
    "TimeUnitsID" integer,
    "TimeUnitsName" character varying(255) DEFAULT NULL::character varying,
    "DataType" character varying(255) DEFAULT NULL::character varying,
    "GeneralCategory" character varying(255) DEFAULT NULL::character varying,
    "MethodID" integer,
    "MethodDescription" text,
    "SourceID" integer,
    "Organization" character varying(255) DEFAULT NULL::character varying,
    "SourceDescription" text,
    "Citation" text,
    "QualityControlLevelID" integer,
    "QualityControlLevelCode" character varying(50) DEFAULT NULL::character varying,
    "BeginDateTime" timestamp without time zone,
    "EndDateTime" timestamp without time zone,
    "BeginDateTimeUTC" timestamp without time zone,
    "EndDateTimeUTC" timestamp without time zone,
    "ValueCount" integer
);


ALTER TABLE public."SeriesCatalog" OWNER TO wmlclient;

--
-- Name: Sites; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."Sites" (
    "SiteID" integer NOT NULL,
    "SiteCode" character varying(50) NOT NULL,
    "SiteName" character varying(255) NOT NULL,
    "Latitude" real NOT NULL,
    "Longitude" real NOT NULL,
    "LatLongDatumID" integer DEFAULT 0 NOT NULL,
    "SiteType" character varying(255) DEFAULT NULL::character varying,
    "Elevation_m" real,
    "VerticalDatum" character varying(255) DEFAULT NULL::character varying,
    "LocalX" real,
    "LocalY" real,
    "LocalProjectionID" integer,
    "PosAccuracy_m" real,
    "State" character varying(255) DEFAULT NULL::character varying,
    "County" character varying(255) DEFAULT NULL::character varying,
    "Comments" text,
    "Country" character varying(255) DEFAULT NULL::character varying,
    "Geometry" public.geometry,
    "FeatureType" character varying(50) DEFAULT 'point'::character varying
);


ALTER TABLE public."Sites" OWNER TO wmlclient;

--
-- Name: Sources; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."Sources" (
    "SourceID" integer NOT NULL,
    "Organization" character varying(255) NOT NULL,
    "SourceDescription" text NOT NULL,
    "SourceLink" text,
    "ContactName" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "Phone" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "Email" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "Address" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "City" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "State" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "ZipCode" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "Citation" text,
    "MetadataID" integer DEFAULT 0 NOT NULL,
    "SourceCode" character varying
);


ALTER TABLE public."Sources" OWNER TO wmlclient;

--
-- Name: Units; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."Units" (
    "UnitsID" integer NOT NULL,
    "UnitsName" character varying(255) NOT NULL,
    "UnitsType" character varying(255) NOT NULL,
    "UnitsAbbreviation" character varying(255) NOT NULL
);


ALTER TABLE public."Units" OWNER TO wmlclient;

--
-- Name: Variables; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."Variables" (
    "VariableID" integer NOT NULL,
    "VariableCode" character varying(50) NOT NULL,
    "VariableName" character varying(255) NOT NULL,
    "Speciation" character varying(255) DEFAULT 'Not Applicable'::character varying NOT NULL,
    "VariableUnitsID" integer NOT NULL,
    "SampleMedium" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "ValueType" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "IsRegular" boolean DEFAULT false NOT NULL,
    "TimeSupport" real DEFAULT 0 NOT NULL,
    "TimeUnitsID" integer DEFAULT 0 NOT NULL,
    "DataType" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "GeneralCategory" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "NoDataValue" real DEFAULT 0 NOT NULL
);


ALTER TABLE public."Variables" OWNER TO wmlclient;

--
-- Name: SeriesCatalogView; Type: MATERIALIZED VIEW; Schema: public; Owner: wmclient
--

CREATE MATERIALIZED VIEW public."SeriesCatalogView" AS
 WITH timeunits AS (
         SELECT "Units"."UnitsID",
            "Units"."UnitsName",
            "Units"."UnitsType",
            "Units"."UnitsAbbreviation"
           FROM public."Units"
        ), series AS (
         SELECT "Sites"."SiteID",
            "Sites"."SiteCode",
            "Sites"."SiteName",
            "Sites"."SiteType",
            "Variables"."VariableID",
            "Variables"."VariableCode",
            "Variables"."VariableName",
            "Variables"."Speciation",
            "Variables"."VariableUnitsID",
            "Units"."UnitsName" AS "VariableUnitsName",
            "Variables"."SampleMedium",
            "Variables"."ValueType",
            "Variables"."TimeSupport",
            "Variables"."TimeUnitsID",
            timeunits."UnitsName" AS "TimeUnitsName",
            "Variables"."DataType",
            "Variables"."GeneralCategory",
            "Methods"."MethodID",
            "Methods"."MethodDescription",
            "Sources"."SourceID",
            "Sources"."Organization",
            "Sources"."SourceDescription",
            "Sources"."Citation",
            "QualityControlLevels"."QualityControlLevelID",
            "QualityControlLevels"."QualityControlLevelCode",
            min("DataValues"."LocalDateTime") AS "BeginDateTime",
            max("DataValues"."LocalDateTime") AS "EndDateTime",
            min("DataValues"."DateTimeUTC") AS "BeginDateTimeUTC",
            max("DataValues"."DateTimeUTC") AS "EndDateTimeUTC",
            count("DataValues"."DataValue") AS "ValueCount"
           FROM public."Sites",
            public."Variables",
            public."Sources",
            public."DataValues",
            public."QualityControlLevels",
            public."Methods",
            public."Units",
            timeunits
          WHERE (("Sites"."SiteID" = "DataValues"."SiteID") AND ("Variables"."VariableID" = "DataValues"."VariableID") AND ("Sources"."SourceID" = "DataValues"."SourceID") AND ("QualityControlLevels"."QualityControlLevelID" = "DataValues"."QualityControlLevelID") AND ("Methods"."MethodID" = "DataValues"."MethodID") AND ("Units"."UnitsID" = "Variables"."VariableUnitsID") AND (timeunits."UnitsID" = "Variables"."TimeUnitsID"))
          GROUP BY "Sites"."SiteID", "Sites"."SiteCode", "Sites"."SiteName", "Sites"."SiteType", "Variables"."VariableID", "Variables"."VariableCode", "Variables"."VariableName", "Variables"."Speciation", "Variables"."VariableUnitsID", "Units"."UnitsName", "Variables"."SampleMedium", "Variables"."ValueType", "Variables"."TimeSupport", "Variables"."TimeUnitsID", timeunits."UnitsName", "Variables"."DataType", "Variables"."GeneralCategory", "Methods"."MethodID", "Methods"."MethodDescription", "Sources"."SourceID", "Sources"."Organization", "Sources"."SourceDescription", "Sources"."Citation", "QualityControlLevels"."QualityControlLevelID", "QualityControlLevels"."QualityControlLevelCode"
          ORDER BY "Sites"."SiteID", "Sites"."SiteCode", "Sites"."SiteName", "Sites"."SiteType", "Variables"."VariableID", "Variables"."VariableCode", "Variables"."VariableName", "Variables"."Speciation", "Variables"."VariableUnitsID", "Units"."UnitsName", "Variables"."SampleMedium", "Variables"."ValueType", "Variables"."TimeSupport", "Variables"."TimeUnitsID", timeunits."UnitsName", "Variables"."DataType", "Variables"."GeneralCategory", "Methods"."MethodID", "Methods"."MethodDescription", "Sources"."SourceID", "Sources"."Organization", "Sources"."SourceDescription", "Sources"."Citation", "QualityControlLevels"."QualityControlLevelID", "QualityControlLevels"."QualityControlLevelCode"
        )
 SELECT row_number() OVER (ORDER BY series."SiteID", series."VariableID", series."SourceID") AS "SeriesID",
    series."SiteID",
    series."SiteCode",
    series."SiteName",
    series."SiteType",
    series."VariableID",
    series."VariableCode",
    series."VariableName",
    series."Speciation",
    series."VariableUnitsID",
    series."VariableUnitsName",
    series."SampleMedium",
    series."ValueType",
    series."TimeSupport",
    series."TimeUnitsID",
    series."TimeUnitsName",
    series."DataType",
    series."GeneralCategory",
    series."MethodID",
    series."MethodDescription",
    series."SourceID",
    series."Organization",
    series."SourceDescription",
    series."Citation",
    series."QualityControlLevelID",
    series."QualityControlLevelCode",
    series."BeginDateTime",
    series."EndDateTime",
    series."BeginDateTimeUTC",
    series."EndDateTimeUTC",
    series."ValueCount"
   FROM series
  WITH NO DATA;


ALTER TABLE public."SeriesCatalogView" OWNER TO wmlclient;

--
-- Name: UnitsXML; Type: VIEW; Schema: public; Owner: wmclient
--

CREATE VIEW public."UnitsXML" AS
 SELECT "Units"."UnitsName",
    "Units"."UnitsID",
    "Units"."UnitsType",
    "Units"."UnitsAbbreviation",
    XMLELEMENT(NAME unit, XMLATTRIBUTES("Units"."UnitsID" AS "unitsID"), XMLELEMENT(NAME "unitsName", "Units"."UnitsName"), XMLELEMENT(NAME "unitsType", "Units"."UnitsType"), XMLELEMENT(NAME "unitsAbbreviation", "Units"."UnitsAbbreviation")) AS "UnitsXML"
   FROM public."Units"
  ORDER BY "Units"."UnitsID";


ALTER TABLE public."UnitsXML" OWNER TO wmlclient;

--
-- Name: VariableInfoXML; Type: VIEW; Schema: public; Owner: wmclient
--

CREATE VIEW public."VariableInfoXML" AS
 SELECT "Variables"."VariableID",
    "Variables"."VariableCode",
    "Variables"."VariableName",
    "Variables"."Speciation",
    "Variables"."VariableUnitsID",
    "Variables"."SampleMedium",
    "Variables"."ValueType",
    "Variables"."IsRegular",
    "Variables"."TimeSupport",
    "Variables"."TimeUnitsID",
    "Variables"."DataType",
    "Variables"."GeneralCategory",
    "Variables"."NoDataValue",
    XMLELEMENT(NAME variable, XMLELEMENT(NAME "variableCode", XMLATTRIBUTES(true AS "default", "Variables"."VariableID" AS "variableID"), "Variables"."VariableCode"), XMLELEMENT(NAME "variableName", "Variables"."VariableName"), XMLELEMENT(NAME "variableDescription", ''), XMLELEMENT(NAME "valueType", "Variables"."ValueType"), XMLELEMENT(NAME "dataType", "Variables"."DataType"), XMLELEMENT(NAME "generalCategory", "Variables"."GeneralCategory"), "UnitsXML"."UnitsXML", XMLELEMENT(NAME "timeScale", XMLATTRIBUTES("Variables"."IsRegular" AS "isRegular"), XMLELEMENT(NAME unit, timeunits."UnitsXML"), XMLELEMENT(NAME "timeSupport", "Variables"."TimeSupport"), XMLELEMENT(NAME "timeSpacing",
        CASE
            WHEN ("Variables"."IsRegular" = true) THEN "Variables"."TimeSupport"
            ELSE (0)::real
        END)), XMLELEMENT(NAME "noDataValue", "Variables"."NoDataValue"), XMLELEMENT(NAME "sampleMedium", "Variables"."SampleMedium")) AS "VariableInfoXML"
   FROM public."Variables",
    public."UnitsXML",
    public."UnitsXML" timeunits
  WHERE (("Variables"."VariableUnitsID" = "UnitsXML"."UnitsID") AND ("Variables"."TimeUnitsID" = timeunits."UnitsID"));


ALTER TABLE public."VariableInfoXML" OWNER TO wmlclient;

--
-- Name: SeriesCatalogXML; Type: VIEW; Schema: public; Owner: wmclient
--

CREATE VIEW public."SeriesCatalogXML" AS
 SELECT "SeriesCatalogView"."SeriesID",
    XMLELEMENT(NAME series, XMLATTRIBUTES("SeriesCatalogView"."SeriesID" AS "seriesID"), XMLELEMENT(NAME "dataType", "SeriesCatalogView"."DataType"), XMLELEMENT(NAME variable, "VariableInfoXML"."VariableInfoXML"), XMLELEMENT(NAME "valueCount", "SeriesCatalogView"."ValueCount"), XMLELEMENT(NAME "variableTimeInterval", XMLELEMENT(NAME "beginDateTime", "SeriesCatalogView"."BeginDateTime"), XMLELEMENT(NAME "endDateTime", "SeriesCatalogView"."EndDateTime"), XMLELEMENT(NAME "beginDateTimeUTC", "SeriesCatalogView"."BeginDateTimeUTC"), XMLELEMENT(NAME "endDateTimeUTC", "SeriesCatalogView"."EndDateTimeUTC")), XMLELEMENT(NAME method, XMLATTRIBUTES("SeriesCatalogView"."MethodID" AS "methodID"), XMLELEMENT(NAME "methodCode", ("Methods"."MethodID")::text), XMLELEMENT(NAME "methodDescription", "SeriesCatalogView"."MethodDescription")), XMLELEMENT(NAME source, XMLATTRIBUTES("SeriesCatalogView"."SourceID" AS "sourceID"), XMLELEMENT(NAME "sourceCode", ("Sources"."SourceID")::text), XMLELEMENT(NAME organization, "SeriesCatalogView"."Organization"), XMLELEMENT(NAME "sourceDescription", "SeriesCatalogView"."SourceDescription"), XMLELEMENT(NAME "sourceLink", "Sources"."SourceLink"))) AS "SeriesCatalogXML"
   FROM public."SeriesCatalogView",
    public."VariableInfoXML",
    public."Methods",
    public."Sources"
  WHERE (("SeriesCatalogView"."VariableID" = "VariableInfoXML"."VariableID") AND ("SeriesCatalogView"."SourceID" = "Sources"."SourceID") AND ("SeriesCatalogView"."SourceID" = "Sources"."SourceID"))
  ORDER BY "SeriesCatalogView"."SiteID", "SeriesCatalogView"."VariableID";


ALTER TABLE public."SeriesCatalogXML" OWNER TO wmlclient;

--
-- Name: SeriesCatalogXMLcombinada; Type: VIEW; Schema: public; Owner: wmclient
--

CREATE VIEW public."SeriesCatalogXMLcombinada" AS
 WITH fromview AS (
         SELECT "VariableInfoXML"."VariableID",
            "Sources"."SourceID",
            "SeriesCatalogView"."SiteID",
            "SeriesCatalogView"."SeriesID",
            XMLELEMENT(NAME series, XMLATTRIBUTES("SeriesCatalogView"."SeriesID" AS "seriesID"), XMLELEMENT(NAME "dataType", "SeriesCatalogView"."DataType"), XMLELEMENT(NAME variable, "VariableInfoXML"."VariableInfoXML"), XMLELEMENT(NAME "valueCount", "SeriesCatalogView"."ValueCount"), XMLELEMENT(NAME "variableTimeInterval", XMLELEMENT(NAME "beginDateTime", "SeriesCatalogView"."BeginDateTime"), XMLELEMENT(NAME "endDateTime", "SeriesCatalogView"."EndDateTime"), XMLELEMENT(NAME "beginDateTimeUTC", "SeriesCatalogView"."BeginDateTimeUTC"), XMLELEMENT(NAME "endDateTimeUTC", "SeriesCatalogView"."EndDateTimeUTC")), XMLELEMENT(NAME method, XMLATTRIBUTES("SeriesCatalogView"."MethodID" AS "methodID"), XMLELEMENT(NAME "methodCode", ("Methods"."MethodID")::text), XMLELEMENT(NAME "methodDescription", "SeriesCatalogView"."MethodDescription")), XMLELEMENT(NAME source, XMLATTRIBUTES("SeriesCatalogView"."SourceID" AS "sourceID"), XMLELEMENT(NAME "sourceCode", ("Sources"."SourceID")::text), XMLELEMENT(NAME organization, "SeriesCatalogView"."Organization"), XMLELEMENT(NAME "sourceDescription", "SeriesCatalogView"."SourceDescription"), XMLELEMENT(NAME "sourceLink", "Sources"."SourceLink"))) AS "SeriesCatalogXML"
           FROM public."SeriesCatalogView",
            public."VariableInfoXML",
            public."Methods",
            public."Sources"
          WHERE (("SeriesCatalogView"."VariableID" = "VariableInfoXML"."VariableID") AND ("SeriesCatalogView"."SourceID" = "Sources"."SourceID") AND ("SeriesCatalogView"."MethodID" = "Methods"."MethodID"))
          ORDER BY "SeriesCatalogView"."SiteID", "SeriesCatalogView"."VariableID"
        ), fromtable AS (
         SELECT "VariableInfoXML"."VariableID",
            "Sources"."SourceID",
            "SeriesCatalog"."SiteID",
            "SeriesCatalog"."SeriesID",
            XMLELEMENT(NAME series, XMLATTRIBUTES("SeriesCatalog"."SeriesID" AS "seriesID"), XMLELEMENT(NAME "dataType", "SeriesCatalog"."DataType"), XMLELEMENT(NAME variable, "VariableInfoXML"."VariableInfoXML"), XMLELEMENT(NAME "valueCount", "SeriesCatalog"."ValueCount"), XMLELEMENT(NAME "variableTimeInterval", XMLELEMENT(NAME "beginDateTime", "SeriesCatalog"."BeginDateTime"), XMLELEMENT(NAME "endDateTime", "SeriesCatalog"."EndDateTime"), XMLELEMENT(NAME "beginDateTimeUTC", "SeriesCatalog"."BeginDateTimeUTC"), XMLELEMENT(NAME "endDateTimeUTC", "SeriesCatalog"."EndDateTimeUTC")), XMLELEMENT(NAME method, XMLATTRIBUTES("SeriesCatalog"."MethodID" AS "methodID"), XMLELEMENT(NAME "methodCode", ("Methods"."MethodID")::text), XMLELEMENT(NAME "methodDescription", "SeriesCatalog"."MethodDescription")), XMLELEMENT(NAME source, XMLATTRIBUTES("SeriesCatalog"."SourceID" AS "sourceID"), XMLELEMENT(NAME "sourceCode", ("Sources"."SourceID")::text), XMLELEMENT(NAME organization, "SeriesCatalog"."Organization"), XMLELEMENT(NAME "sourceDescription", "SeriesCatalog"."SourceDescription"), XMLELEMENT(NAME "sourceLink", "Sources"."SourceLink"))) AS "SeriesCatalogXML"
           FROM public."SeriesCatalog",
            public."VariableInfoXML",
            public."Methods",
            public."Sources"
          WHERE (("SeriesCatalog"."VariableID" = "VariableInfoXML"."VariableID") AND ("SeriesCatalog"."SourceID" = "Sources"."SourceID") AND ("SeriesCatalog"."MethodID" = "Methods"."MethodID"))
          ORDER BY "SeriesCatalog"."SiteID", "SeriesCatalog"."VariableID"
        ), fromall AS (
         SELECT "Sites"."SiteID",
            "Variables"."VariableID",
            COALESCE(fromview."SeriesCatalogXML", fromtable."SeriesCatalogXML") AS "SeriesCatalogXML",
            COALESCE(fromview."SeriesID", (fromtable."SeriesID")::bigint) AS "SeriesID"
           FROM (((public."Sites"
             JOIN public."Variables" ON (("Sites"."SiteID" IS NOT NULL)))
             LEFT JOIN fromview ON ((("Sites"."SiteID" = fromview."SiteID") AND ("Variables"."VariableID" = fromview."VariableID"))))
             LEFT JOIN fromtable ON ((("Sites"."SiteID" = fromtable."SiteID") AND ("Variables"."VariableID" = fromtable."VariableID"))))
        )
 SELECT fromall."SiteID",
    fromall."VariableID",
    fromall."SeriesCatalogXML",
    fromall."SeriesID"
   FROM fromall
  WHERE (fromall."SeriesCatalogXML" IS NOT NULL)
  ORDER BY fromall."SiteID", fromall."VariableID";


ALTER TABLE public."SeriesCatalogXMLcombinada" OWNER TO wmlclient;

--
-- Name: SeriesCatalog_SeriesID_seq; Type: SEQUENCE; Schema: public; Owner: wmclient
--

CREATE SEQUENCE public."SeriesCatalog_SeriesID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."SeriesCatalog_SeriesID_seq" OWNER TO wmlclient;

--
-- Name: SeriesCatalog_SeriesID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmclient
--

ALTER SEQUENCE public."SeriesCatalog_SeriesID_seq" OWNED BY public."SeriesCatalog"."SeriesID";


--
-- Name: SiteInfoXML; Type: VIEW; Schema: public; Owner: wmclient
--

CREATE VIEW public."SiteInfoXML" AS
 SELECT "Sites"."SiteID",
    XMLELEMENT(NAME "siteInfo", XMLATTRIBUTES("Sites"."SiteID" AS oid), XMLELEMENT(NAME "siteName", "Sites"."SiteName"), XMLELEMENT(NAME "siteCode", XMLATTRIBUTES(true AS "defaultId", "Sites"."SiteID" AS "siteID", 'SAT-CDP INA' AS network, 'INA' AS "agencyCode", 'INA' AS "agencyName"), "Sites"."SiteCode"), XMLELEMENT(NAME "timeZoneInfo", XMLATTRIBUTES(false AS "siteUsesDaylightSavingsTime"), XMLELEMENT(NAME "defaultTimeZone", '-03')), XMLELEMENT(NAME "geoLocation", XMLELEMENT(NAME "geogLocation", XMLATTRIBUTES('LatLonPointType' AS "xsi:type", 'EPSG:4326' AS srs), XMLELEMENT(NAME latitude, "Sites"."Latitude"), XMLELEMENT(NAME longitude, "Sites"."Longitude")), XMLELEMENT(NAME "localSiteXY", XMLATTRIBUTES((spatial_ref_sys.auth_name)::text AS "projectionInformation"), XMLELEMENT(NAME "X", public.st_x("Sites"."Geometry")), XMLELEMENT(NAME "Y", public.st_y("Sites"."Geometry")))), XMLELEMENT(NAME elevation_m, "Sites"."Elevation_m"), XMLELEMENT(NAME "verticalDatum", "Sites"."VerticalDatum"), XMLELEMENT(NAME "siteProperty", XMLATTRIBUTES('Country' AS title), "Sites"."Country"), XMLELEMENT(NAME "siteProperty", XMLATTRIBUTES('State' AS title), "Sites"."State"), XMLELEMENT(NAME "siteProperty", XMLATTRIBUTES('Site Comments' AS title), "Sites"."Comments")) AS "SiteInfoXML"
   FROM public."Sites",
    public.spatial_ref_sys
  WHERE (public.st_srid("Sites"."Geometry") = spatial_ref_sys.srid)
  ORDER BY "Sites"."SiteID";


ALTER TABLE public."SiteInfoXML" OWNER TO wmlclient;

--
-- Name: SiteTypeCV; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."SiteTypeCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."SiteTypeCV" OWNER TO wmlclient;

--
-- Name: SitesWithSeriesCatalogXML; Type: VIEW; Schema: public; Owner: wmclient
--

CREATE VIEW public."SitesWithSeriesCatalogXML" AS
 WITH siteseriesagg AS (
         SELECT "Sites"."SiteID",
            xmlagg("SeriesCatalogXMLcombinada"."SeriesCatalogXML") AS "seriesCatalog"
           FROM public."Sites",
            public."SeriesCatalogXMLcombinada"
          WHERE ("Sites"."SiteID" = "SeriesCatalogXMLcombinada"."SiteID")
          GROUP BY "Sites"."SiteID"
        )
 SELECT "SiteInfoXML"."SiteID",
    XMLELEMENT(NAME site, "SiteInfoXML"."SiteInfoXML", XMLELEMENT(NAME "seriesCatalog", siteseriesagg."seriesCatalog")) AS site
   FROM (public."SiteInfoXML"
     LEFT JOIN siteseriesagg ON (("SiteInfoXML"."SiteID" = siteseriesagg."SiteID")))
  ORDER BY "SiteInfoXML"."SiteID";


ALTER TABLE public."SitesWithSeriesCatalogXML" OWNER TO wmlclient;

--
-- Name: Sites_SiteID_seq; Type: SEQUENCE; Schema: public; Owner: wmclient
--

CREATE SEQUENCE public."Sites_SiteID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Sites_SiteID_seq" OWNER TO wmlclient;

--
-- Name: Sites_SiteID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmclient
--

ALTER SEQUENCE public."Sites_SiteID_seq" OWNED BY public."Sites"."SiteID";


--
-- Name: SourceInfoXML; Type: VIEW; Schema: public; Owner: wmclient
--

CREATE VIEW public."SourceInfoXML" AS
 SELECT "Sources"."SourceID",
    XMLELEMENT(NAME "sr:source", XMLELEMENT(NAME "sourceID", XMLATTRIBUTES(true AS "default", "Sources"."SourceID" AS "SourceID"), "Sources"."SourceID"), XMLELEMENT(NAME "Organization", "Sources"."Organization"), XMLELEMENT(NAME "SourceDescription", "Sources"."SourceDescription"), XMLELEMENT(NAME "SourceLink", "Sources"."SourceLink")) AS "SourceInfoXML"
   FROM public."Sources";


ALTER TABLE public."SourceInfoXML" OWNER TO wmlclient;

--
-- Name: Sources_SourceID_seq; Type: SEQUENCE; Schema: public; Owner: wmclient
--

CREATE SEQUENCE public."Sources_SourceID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Sources_SourceID_seq" OWNER TO wmlclient;

--
-- Name: Sources_SourceID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmclient
--

ALTER SEQUENCE public."Sources_SourceID_seq" OWNED BY public."Sources"."SourceID";


--
-- Name: SpatialReferences; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."SpatialReferences" (
    "SpatialReferenceID" integer NOT NULL,
    "SRSID" integer,
    "SRSName" character varying(255) NOT NULL,
    "IsGeographic" boolean,
    "Notes" text
);


ALTER TABLE public."SpatialReferences" OWNER TO wmlclient;

--
-- Name: SpatialReferences_SpatialReferenceID_seq; Type: SEQUENCE; Schema: public; Owner: wmclient
--

CREATE SEQUENCE public."SpatialReferences_SpatialReferenceID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."SpatialReferences_SpatialReferenceID_seq" OWNER TO wmlclient;

--
-- Name: SpatialReferences_SpatialReferenceID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmclient
--

ALTER SEQUENCE public."SpatialReferences_SpatialReferenceID_seq" OWNED BY public."SpatialReferences"."SpatialReferenceID";


--
-- Name: SpeciationCV; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."SpeciationCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."SpeciationCV" OWNER TO wmlclient;

--
-- Name: TopicCategoryCV; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."TopicCategoryCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."TopicCategoryCV" OWNER TO wmlclient;

--
-- Name: Units_UnitsID_seq; Type: SEQUENCE; Schema: public; Owner: wmclient
--

CREATE SEQUENCE public."Units_UnitsID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Units_UnitsID_seq" OWNER TO wmlclient;

--
-- Name: Units_UnitsID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmclient
--

ALTER SEQUENCE public."Units_UnitsID_seq" OWNED BY public."Units"."UnitsID";


--
-- Name: ValueTypeCV; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."ValueTypeCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."ValueTypeCV" OWNER TO wmlclient;

--
-- Name: ValuesXML; Type: VIEW; Schema: public; Owner: wmclient
--

CREATE VIEW public."ValuesXML" AS
 SELECT "DataValues"."ValueID",
    XMLELEMENT(NAME "sr:value", XMLATTRIBUTES("DataValues"."LocalDateTime" AS "dateTime", "DataValues"."DateTimeUTC" AS "dateTimeUTC", "DataValues"."MethodID" AS "methodID", "DataValues"."SourceID" AS "sourceID", "DataValues"."SampleID" AS "sampleID", "DataValues"."ValueID" AS oid, "DataValues"."UTCOffset" AS "timeOffset"), "DataValues"."DataValue") AS "ValueXML"
   FROM public."DataValues";


ALTER TABLE public."ValuesXML" OWNER TO wmlclient;

--
-- Name: VariableNameCV; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."VariableNameCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."VariableNameCV" OWNER TO wmlclient;

--
-- Name: Variables_VariableID_seq; Type: SEQUENCE; Schema: public; Owner: wmclient
--

CREATE SEQUENCE public."Variables_VariableID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Variables_VariableID_seq" OWNER TO wmlclient;

--
-- Name: Variables_VariableID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmclient
--

ALTER SEQUENCE public."Variables_VariableID_seq" OWNED BY public."Variables"."VariableID";


--
-- Name: VerticalDatumCV; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public."VerticalDatumCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."VerticalDatumCV" OWNER TO wmlclient;

--
-- Name: series_catalog_w_geom; Type: TABLE; Schema: public; Owner: wmclient
--

CREATE TABLE public.series_catalog_w_geom (
    "SeriesID" integer,
    "SiteID" integer,
    "SiteCode" character varying(50),
    "SiteName" character varying(255),
    "SiteType" character varying(255),
    "VariableID" integer,
    "VariableCode" character varying(50),
    "VariableName" character varying(255),
    "Speciation" character varying(255),
    "VariableUnitsID" integer,
    "VariableUnitsName" character varying(255),
    "SampleMedium" character varying(255),
    "ValueType" character varying(255),
    "TimeSupport" real,
    "TimeUnitsID" integer,
    "TimeUnitsName" character varying(255),
    "DataType" character varying(255),
    "GeneralCategory" character varying(255),
    "MethodID" integer,
    "MethodDescription" text,
    "SourceID" integer,
    "Organization" character varying(255),
    "SourceDescription" text,
    "Citation" text,
    "QualityControlLevelID" integer,
    "QualityControlLevelCode" character varying(50),
    "BeginDateTime" timestamp without time zone,
    "EndDateTime" timestamp without time zone,
    "BeginDateTimeUTC" timestamp without time zone,
    "EndDateTimeUTC" timestamp without time zone,
    "ValueCount" integer,
    "Geometry" public.geometry
);


ALTER TABLE public.series_catalog_w_geom OWNER TO wmlclient;

--
-- Name: DataValues ValueID; Type: DEFAULT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."DataValues" ALTER COLUMN "ValueID" SET DEFAULT nextval('public."DataValues_ValueID_seq"'::regclass);


--
-- Name: FeatureTypeCV FeatureTypeID; Type: DEFAULT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."FeatureTypeCV" ALTER COLUMN "FeatureTypeID" SET DEFAULT nextval('public."FeatureTypeCV_FeatureTypeID_seq"'::regclass);


--
-- Name: GroupDescriptions GroupID; Type: DEFAULT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."GroupDescriptions" ALTER COLUMN "GroupID" SET DEFAULT nextval('public."GroupDescriptions_GroupID_seq"'::regclass);


--
-- Name: ISOMetadata MetadataID; Type: DEFAULT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."ISOMetadata" ALTER COLUMN "MetadataID" SET DEFAULT nextval('public."ISOMetadata_MetadataID_seq"'::regclass);


--
-- Name: LabMethods LabMethodID; Type: DEFAULT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."LabMethods" ALTER COLUMN "LabMethodID" SET DEFAULT nextval('public."LabMethods_LabMethodID_seq"'::regclass);


--
-- Name: Methods MethodID; Type: DEFAULT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Methods" ALTER COLUMN "MethodID" SET DEFAULT nextval('public."Methods_MethodID_seq"'::regclass);


--
-- Name: OffsetTypes OffsetTypeID; Type: DEFAULT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."OffsetTypes" ALTER COLUMN "OffsetTypeID" SET DEFAULT nextval('public."OffsetTypes_OffsetTypeID_seq"'::regclass);


--
-- Name: Qualifiers QualifierID; Type: DEFAULT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Qualifiers" ALTER COLUMN "QualifierID" SET DEFAULT nextval('public."Qualifiers_QualifierID_seq"'::regclass);


--
-- Name: QualityControlLevels QualityControlLevelID; Type: DEFAULT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."QualityControlLevels" ALTER COLUMN "QualityControlLevelID" SET DEFAULT nextval('public."QualityControlLevels_QualityControlLevelID_seq"'::regclass);


--
-- Name: Samples SampleID; Type: DEFAULT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Samples" ALTER COLUMN "SampleID" SET DEFAULT nextval('public."Samples_SampleID_seq"'::regclass);


--
-- Name: SeriesCatalog SeriesID; Type: DEFAULT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."SeriesCatalog" ALTER COLUMN "SeriesID" SET DEFAULT nextval('public."SeriesCatalog_SeriesID_seq"'::regclass);


--
-- Name: Sites SiteID; Type: DEFAULT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Sites" ALTER COLUMN "SiteID" SET DEFAULT nextval('public."Sites_SiteID_seq"'::regclass);


--
-- Name: Sources SourceID; Type: DEFAULT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Sources" ALTER COLUMN "SourceID" SET DEFAULT nextval('public."Sources_SourceID_seq"'::regclass);


--
-- Name: SpatialReferences SpatialReferenceID; Type: DEFAULT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."SpatialReferences" ALTER COLUMN "SpatialReferenceID" SET DEFAULT nextval('public."SpatialReferences_SpatialReferenceID_seq"'::regclass);


--
-- Name: Units UnitsID; Type: DEFAULT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Units" ALTER COLUMN "UnitsID" SET DEFAULT nextval('public."Units_UnitsID_seq"'::regclass);


--
-- Name: Variables VariableID; Type: DEFAULT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Variables" ALTER COLUMN "VariableID" SET DEFAULT nextval('public."Variables_VariableID_seq"'::regclass);


--
-- Name: CensorCodeCV CensorCodeCV_pkey; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."CensorCodeCV"
    ADD CONSTRAINT "CensorCodeCV_pkey" PRIMARY KEY ("Term");


--
-- Name: DataTypeCV DataTypeCV_pkey; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."DataTypeCV"
    ADD CONSTRAINT "DataTypeCV_pkey" PRIMARY KEY ("Term");


--
-- Name: DataValues DataValues_DataValue_ValueAccuracy_LocalDateTime_UTCOffset__key; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_DataValue_ValueAccuracy_LocalDateTime_UTCOffset__key" UNIQUE ("DataValue", "ValueAccuracy", "LocalDateTime", "UTCOffset", "DateTimeUTC", "SiteID", "VariableID", "OffsetValue", "OffsetTypeID", "CensorCode", "QualifierID", "MethodID", "SourceID", "SampleID", "DerivedFromID", "QualityControlLevelID");


--
-- Name: DataValues DataValues_SiteID_VariableID_SourceID_DateTimeUTC_key; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_SiteID_VariableID_SourceID_DateTimeUTC_key" UNIQUE ("SiteID", "VariableID", "SourceID", "DateTimeUTC");


--
-- Name: DataValues DataValues_pkey; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_pkey" PRIMARY KEY ("ValueID");


--
-- Name: FeatureTypeCV FeatureTypeCV_FeatureTypeID_key; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."FeatureTypeCV"
    ADD CONSTRAINT "FeatureTypeCV_FeatureTypeID_key" UNIQUE ("FeatureTypeID");


--
-- Name: FeatureTypeCV FeatureTypeCV_FeatureTypeName_key; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."FeatureTypeCV"
    ADD CONSTRAINT "FeatureTypeCV_FeatureTypeName_key" UNIQUE ("FeatureTypeName");


--
-- Name: FeatureTypeCV FeatureTypeCV_pkey; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."FeatureTypeCV"
    ADD CONSTRAINT "FeatureTypeCV_pkey" PRIMARY KEY ("FeatureTypeID");


--
-- Name: GeneralCategoryCV GeneralCategoryCV_pkey; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."GeneralCategoryCV"
    ADD CONSTRAINT "GeneralCategoryCV_pkey" PRIMARY KEY ("Term");


--
-- Name: GroupDescriptions GroupDescriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."GroupDescriptions"
    ADD CONSTRAINT "GroupDescriptions_pkey" PRIMARY KEY ("GroupID");


--
-- Name: ISOMetadata ISOMetadata_pkey; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."ISOMetadata"
    ADD CONSTRAINT "ISOMetadata_pkey" PRIMARY KEY ("MetadataID");


--
-- Name: LabMethods LabMethods_pkey; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."LabMethods"
    ADD CONSTRAINT "LabMethods_pkey" PRIMARY KEY ("LabMethodID");


--
-- Name: Methods Methods_MethodCode_key; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Methods"
    ADD CONSTRAINT "Methods_MethodCode_key" UNIQUE ("MethodCode");


--
-- Name: Methods Methods_pkey; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Methods"
    ADD CONSTRAINT "Methods_pkey" PRIMARY KEY ("MethodID");


--
-- Name: OffsetTypes OffsetTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."OffsetTypes"
    ADD CONSTRAINT "OffsetTypes_pkey" PRIMARY KEY ("OffsetTypeID");


--
-- Name: Qualifiers Qualifiers_pkey; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Qualifiers"
    ADD CONSTRAINT "Qualifiers_pkey" PRIMARY KEY ("QualifierID");


--
-- Name: QualityControlLevels QualityControlLevels_pkey; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."QualityControlLevels"
    ADD CONSTRAINT "QualityControlLevels_pkey" PRIMARY KEY ("QualityControlLevelID");


--
-- Name: SampleMediumCV SampleMediumCV_pkey; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."SampleMediumCV"
    ADD CONSTRAINT "SampleMediumCV_pkey" PRIMARY KEY ("Term");


--
-- Name: SampleTypeCV SampleTypeCV_pkey; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."SampleTypeCV"
    ADD CONSTRAINT "SampleTypeCV_pkey" PRIMARY KEY ("Term");


--
-- Name: Samples Samples_pkey; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Samples"
    ADD CONSTRAINT "Samples_pkey" PRIMARY KEY ("SampleID");


--
-- Name: SeriesCatalog SeriesCatalog_SiteID_VariableID_key; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."SeriesCatalog"
    ADD CONSTRAINT "SeriesCatalog_SiteID_VariableID_key" UNIQUE ("SiteID", "VariableID");


--
-- Name: SeriesCatalog SeriesCatalog_pkey; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."SeriesCatalog"
    ADD CONSTRAINT "SeriesCatalog_pkey" PRIMARY KEY ("SeriesID");


--
-- Name: SiteTypeCV SiteTypeCV_pkey; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."SiteTypeCV"
    ADD CONSTRAINT "SiteTypeCV_pkey" PRIMARY KEY ("Term");


--
-- Name: Sites Sites_SiteCode_key; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Sites"
    ADD CONSTRAINT "Sites_SiteCode_key" UNIQUE ("SiteCode");


--
-- Name: Sites Sites_pkey; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Sites"
    ADD CONSTRAINT "Sites_pkey" PRIMARY KEY ("SiteID");


--
-- Name: Sources Sources_SourceCode_key; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Sources"
    ADD CONSTRAINT "Sources_SourceCode_key" UNIQUE ("SourceCode");


--
-- Name: Sources Sources_pkey; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Sources"
    ADD CONSTRAINT "Sources_pkey" PRIMARY KEY ("SourceID");


--
-- Name: SpatialReferences SpatialReferences_pkey; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."SpatialReferences"
    ADD CONSTRAINT "SpatialReferences_pkey" PRIMARY KEY ("SpatialReferenceID");


--
-- Name: SpeciationCV SpeciationCV_pkey; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."SpeciationCV"
    ADD CONSTRAINT "SpeciationCV_pkey" PRIMARY KEY ("Term");


--
-- Name: TopicCategoryCV TopicCategoryCV_pkey; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."TopicCategoryCV"
    ADD CONSTRAINT "TopicCategoryCV_pkey" PRIMARY KEY ("Term");


--
-- Name: Units Units_pkey; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Units"
    ADD CONSTRAINT "Units_pkey" PRIMARY KEY ("UnitsID");


--
-- Name: ValueTypeCV ValueTypeCV_pkey; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."ValueTypeCV"
    ADD CONSTRAINT "ValueTypeCV_pkey" PRIMARY KEY ("Term");


--
-- Name: VariableNameCV VariableNameCV_pkey; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."VariableNameCV"
    ADD CONSTRAINT "VariableNameCV_pkey" PRIMARY KEY ("Term");


--
-- Name: Variables Variables_VariableCode_key; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_VariableCode_key" UNIQUE ("VariableCode");


--
-- Name: Variables Variables_pkey; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_pkey" PRIMARY KEY ("VariableID");


--
-- Name: VerticalDatumCV VerticalDatumCV_pkey; Type: CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."VerticalDatumCV"
    ADD CONSTRAINT "VerticalDatumCV_pkey" PRIMARY KEY ("Term");


--
-- Name: Sites geom_default; Type: TRIGGER; Schema: public; Owner: wmclient
--

CREATE TRIGGER geom_default BEFORE INSERT ON public."Sites" FOR EACH ROW WHEN (((new."Geometry" IS NULL) AND (new."Longitude" IS NOT NULL) AND (new."Latitude" IS NOT NULL))) EXECUTE PROCEDURE public.trg_geom_default();


--
-- Name: Categories Categories_VariableID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Categories"
    ADD CONSTRAINT "Categories_VariableID_fkey" FOREIGN KEY ("VariableID") REFERENCES public."Variables"("VariableID");


--
-- Name: DataValues DataValues_CensorCode_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_CensorCode_fkey" FOREIGN KEY ("CensorCode") REFERENCES public."CensorCodeCV"("Term");


--
-- Name: DataValues DataValues_MethodID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_MethodID_fkey" FOREIGN KEY ("MethodID") REFERENCES public."Methods"("MethodID");


--
-- Name: DataValues DataValues_OffsetTypeID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_OffsetTypeID_fkey" FOREIGN KEY ("OffsetTypeID") REFERENCES public."OffsetTypes"("OffsetTypeID");


--
-- Name: DataValues DataValues_QualifierID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_QualifierID_fkey" FOREIGN KEY ("QualifierID") REFERENCES public."Qualifiers"("QualifierID");


--
-- Name: DataValues DataValues_QualityControlLevelID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_QualityControlLevelID_fkey" FOREIGN KEY ("QualityControlLevelID") REFERENCES public."QualityControlLevels"("QualityControlLevelID");


--
-- Name: DataValues DataValues_SampleID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_SampleID_fkey" FOREIGN KEY ("SampleID") REFERENCES public."Samples"("SampleID");


--
-- Name: DataValues DataValues_SiteID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_SiteID_fkey" FOREIGN KEY ("SiteID") REFERENCES public."Sites"("SiteID") ON UPDATE CASCADE;


--
-- Name: DataValues DataValues_SourceID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_SourceID_fkey" FOREIGN KEY ("SourceID") REFERENCES public."Sources"("SourceID");


--
-- Name: DataValues DataValues_VariableID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_VariableID_fkey" FOREIGN KEY ("VariableID") REFERENCES public."Variables"("VariableID");


--
-- Name: DerivedFrom DerivedFrom_ValueID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."DerivedFrom"
    ADD CONSTRAINT "DerivedFrom_ValueID_fkey" FOREIGN KEY ("ValueID") REFERENCES public."DataValues"("ValueID");


--
-- Name: Groups Groups_GroupID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Groups"
    ADD CONSTRAINT "Groups_GroupID_fkey" FOREIGN KEY ("GroupID") REFERENCES public."GroupDescriptions"("GroupID");


--
-- Name: Groups Groups_ValueID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Groups"
    ADD CONSTRAINT "Groups_ValueID_fkey" FOREIGN KEY ("ValueID") REFERENCES public."DataValues"("ValueID");


--
-- Name: ISOMetadata ISOMetadata_TopicCategory_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."ISOMetadata"
    ADD CONSTRAINT "ISOMetadata_TopicCategory_fkey" FOREIGN KEY ("TopicCategory") REFERENCES public."TopicCategoryCV"("Term");


--
-- Name: OffsetTypes OffsetTypes_OffsetUnitsID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."OffsetTypes"
    ADD CONSTRAINT "OffsetTypes_OffsetUnitsID_fkey" FOREIGN KEY ("OffsetUnitsID") REFERENCES public."Units"("UnitsID");


--
-- Name: Samples Samples_LabMethodID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Samples"
    ADD CONSTRAINT "Samples_LabMethodID_fkey" FOREIGN KEY ("LabMethodID") REFERENCES public."LabMethods"("LabMethodID");


--
-- Name: Samples Samples_SampleType_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Samples"
    ADD CONSTRAINT "Samples_SampleType_fkey" FOREIGN KEY ("SampleType") REFERENCES public."SampleTypeCV"("Term");


--
-- Name: SeriesCatalog SeriesCatalog_SiteID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."SeriesCatalog"
    ADD CONSTRAINT "SeriesCatalog_SiteID_fkey" FOREIGN KEY ("SiteID") REFERENCES public."Sites"("SiteID");


--
-- Name: SeriesCatalog SeriesCatalog_VariableID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."SeriesCatalog"
    ADD CONSTRAINT "SeriesCatalog_VariableID_fkey" FOREIGN KEY ("VariableID") REFERENCES public."Variables"("VariableID");


--
-- Name: Sites Sites_FeatureType_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Sites"
    ADD CONSTRAINT "Sites_FeatureType_fkey" FOREIGN KEY ("FeatureType") REFERENCES public."FeatureTypeCV"("FeatureTypeName");


--
-- Name: Sites Sites_LatLongDatumID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Sites"
    ADD CONSTRAINT "Sites_LatLongDatumID_fkey" FOREIGN KEY ("LatLongDatumID") REFERENCES public."SpatialReferences"("SpatialReferenceID");


--
-- Name: Sites Sites_LocalProjectionID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Sites"
    ADD CONSTRAINT "Sites_LocalProjectionID_fkey" FOREIGN KEY ("LocalProjectionID") REFERENCES public."SpatialReferences"("SpatialReferenceID");


--
-- Name: Sites Sites_SiteType_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Sites"
    ADD CONSTRAINT "Sites_SiteType_fkey" FOREIGN KEY ("SiteType") REFERENCES public."SiteTypeCV"("Term");


--
-- Name: Sites Sites_VerticalDatum_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Sites"
    ADD CONSTRAINT "Sites_VerticalDatum_fkey" FOREIGN KEY ("VerticalDatum") REFERENCES public."VerticalDatumCV"("Term");


--
-- Name: Sources Sources_MetadataID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Sources"
    ADD CONSTRAINT "Sources_MetadataID_fkey" FOREIGN KEY ("MetadataID") REFERENCES public."ISOMetadata"("MetadataID");


--
-- Name: Variables Variables_DataType_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_DataType_fkey" FOREIGN KEY ("DataType") REFERENCES public."DataTypeCV"("Term");


--
-- Name: Variables Variables_GeneralCategory_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_GeneralCategory_fkey" FOREIGN KEY ("GeneralCategory") REFERENCES public."GeneralCategoryCV"("Term");


--
-- Name: Variables Variables_SampleMedium_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_SampleMedium_fkey" FOREIGN KEY ("SampleMedium") REFERENCES public."SampleMediumCV"("Term");


--
-- Name: Variables Variables_Speciation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_Speciation_fkey" FOREIGN KEY ("Speciation") REFERENCES public."SpeciationCV"("Term");


--
-- Name: Variables Variables_TimeUnitsID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_TimeUnitsID_fkey" FOREIGN KEY ("TimeUnitsID") REFERENCES public."Units"("UnitsID");


--
-- Name: Variables Variables_ValueType_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_ValueType_fkey" FOREIGN KEY ("ValueType") REFERENCES public."ValueTypeCV"("Term");


--
-- Name: Variables Variables_VariableName_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_VariableName_fkey" FOREIGN KEY ("VariableName") REFERENCES public."VariableNameCV"("Term");


--
-- Name: Variables Variables_VariableUnitsID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmclient
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_VariableUnitsID_fkey" FOREIGN KEY ("VariableUnitsID") REFERENCES public."Units"("UnitsID");


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO wmlclient;


--
-- Name: TABLE "DataValues"; Type: ACL; Schema: public; Owner: wmclient
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."DataValues" TO wmlclient;


--
-- Name: SEQUENCE "DataValues_ValueID_seq"; Type: ACL; Schema: public; Owner: wmclient
--

REVOKE ALL ON SEQUENCE public."DataValues_ValueID_seq" FROM wmlclient;
GRANT ALL ON SEQUENCE public."DataValues_ValueID_seq" TO wmlclient;


--
-- Name: TABLE "Methods"; Type: ACL; Schema: public; Owner: wmclient
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."Methods" TO wmlclient;


--
-- Name: SEQUENCE "Methods_MethodID_seq"; Type: ACL; Schema: public; Owner: wmclient
--

GRANT ALL ON SEQUENCE public."Methods_MethodID_seq" TO wmlclient;


--
-- Name: TABLE "QualityControlLevels"; Type: ACL; Schema: public; Owner: wmclient
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."QualityControlLevels" TO wmlclient;


--
-- Name: TABLE "SeriesCatalog"; Type: ACL; Schema: public; Owner: wmclient
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."SeriesCatalog" TO wmlclient;


--
-- Name: TABLE "Sites"; Type: ACL; Schema: public; Owner: wmclient
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."Sites" TO wmlclient;


--
-- Name: TABLE "Sources"; Type: ACL; Schema: public; Owner: wmclient
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."Sources" TO wmlclient;


--
-- Name: TABLE "Units"; Type: ACL; Schema: public; Owner: wmclient
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."Units" TO wmlclient;


--
-- Name: TABLE "Variables"; Type: ACL; Schema: public; Owner: wmclient
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."Variables" TO wmlclient;


--
-- Name: SEQUENCE "SeriesCatalog_SeriesID_seq"; Type: ACL; Schema: public; Owner: wmclient
--

GRANT SELECT,USAGE ON SEQUENCE public."SeriesCatalog_SeriesID_seq" TO wmlclient;


--
-- Name: SEQUENCE "Sites_SiteID_seq"; Type: ACL; Schema: public; Owner: wmclient
--

GRANT ALL ON SEQUENCE public."Sites_SiteID_seq" TO wmlclient;


--
-- Name: SEQUENCE "Sources_SourceID_seq"; Type: ACL; Schema: public; Owner: wmclient
--

GRANT ALL ON SEQUENCE public."Sources_SourceID_seq" TO wmlclient;


--
-- Name: SEQUENCE "Variables_VariableID_seq"; Type: ACL; Schema: public; Owner: wmclient
--

GRANT ALL ON SEQUENCE public."Variables_VariableID_seq" TO wmlclient;


--
-- Name: TABLE series_catalog_w_geom; Type: ACL; Schema: public; Owner: wmclient
--

GRANT SELECT ON TABLE public.series_catalog_w_geom TO wmlclient;


--
-- PostgreSQL database dump complete
--

