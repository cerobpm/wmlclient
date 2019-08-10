--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.9
-- Dumped by pg_dump version 9.6.9

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: odm; Type: DATABASE; Schema: -; Owner: wmlclient
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
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: wmlclient
--

CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO wmlclient;

--
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: wmlclient
--

CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO wmlclient;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: wmlclient
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO wmlclient;

--
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: wmlclient
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
-- Name: trg_geom_default(); Type: FUNCTION; Schema: public; Owner: wmlclient
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
-- Name: Categories; Type: TABLE; Schema: public; Owner: wmlclient
--

CREATE TABLE public."Categories" (
    "VariableID" integer NOT NULL,
    "DataValue" real NOT NULL,
    "CategoryDescription" text NOT NULL
);


ALTER TABLE public."Categories" OWNER TO wmlclient;

--
-- Name: CensorCodeCV; Type: TABLE; Schema: public; Owner: wmlclient
--

CREATE TABLE public."CensorCodeCV" (
    "Term" character varying(50) NOT NULL,
    "Definition" text
);


ALTER TABLE public."CensorCodeCV" OWNER TO wmlclient;

--
-- Name: DataTypeCV; Type: TABLE; Schema: public; Owner: wmlclient
--

CREATE TABLE public."DataTypeCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."DataTypeCV" OWNER TO wmlclient;

--
-- Name: DataValues; Type: TABLE; Schema: public; Owner: wmlclient
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
-- Name: DataValues_ValueID_seq; Type: SEQUENCE; Schema: public; Owner: wmlclient
--

CREATE SEQUENCE public."DataValues_ValueID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."DataValues_ValueID_seq" OWNER TO wmlclient;

--
-- Name: DataValues_ValueID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmlclient
--

ALTER SEQUENCE public."DataValues_ValueID_seq" OWNED BY public."DataValues"."ValueID";


--
-- Name: DerivedFrom; Type: TABLE; Schema: public; Owner: wmlclient
--

CREATE TABLE public."DerivedFrom" (
    "DerivedFromID" integer NOT NULL,
    "ValueID" integer NOT NULL
);


ALTER TABLE public."DerivedFrom" OWNER TO wmlclient;

--
-- Name: FeatureTypeCV; Type: TABLE; Schema: public; Owner: wmlclient
--

CREATE TABLE public."FeatureTypeCV" (
    "FeatureTypeID" integer NOT NULL,
    "FeatureTypeName" character varying NOT NULL,
    "Description" character varying
);


ALTER TABLE public."FeatureTypeCV" OWNER TO wmlclient;

--
-- Name: FeatureTypeCV_FeatureTypeID_seq; Type: SEQUENCE; Schema: public; Owner: wmlclient
--

CREATE SEQUENCE public."FeatureTypeCV_FeatureTypeID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."FeatureTypeCV_FeatureTypeID_seq" OWNER TO wmlclient;

--
-- Name: FeatureTypeCV_FeatureTypeID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmlclient
--

ALTER SEQUENCE public."FeatureTypeCV_FeatureTypeID_seq" OWNED BY public."FeatureTypeCV"."FeatureTypeID";


--
-- Name: GeneralCategoryCV; Type: TABLE; Schema: public; Owner: wmlclient
--

CREATE TABLE public."GeneralCategoryCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."GeneralCategoryCV" OWNER TO wmlclient;

--
-- Name: GroupDescriptions; Type: TABLE; Schema: public; Owner: wmlclient
--

CREATE TABLE public."GroupDescriptions" (
    "GroupID" integer NOT NULL,
    "GroupDescription" text
);


ALTER TABLE public."GroupDescriptions" OWNER TO wmlclient;

--
-- Name: GroupDescriptions_GroupID_seq; Type: SEQUENCE; Schema: public; Owner: wmlclient
--

CREATE SEQUENCE public."GroupDescriptions_GroupID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."GroupDescriptions_GroupID_seq" OWNER TO wmlclient;

--
-- Name: GroupDescriptions_GroupID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmlclient
--

ALTER SEQUENCE public."GroupDescriptions_GroupID_seq" OWNED BY public."GroupDescriptions"."GroupID";


--
-- Name: Groups; Type: TABLE; Schema: public; Owner: wmlclient
--

CREATE TABLE public."Groups" (
    "GroupID" integer NOT NULL,
    "ValueID" integer NOT NULL
);


ALTER TABLE public."Groups" OWNER TO wmlclient;

--
-- Name: ISOMetadata; Type: TABLE; Schema: public; Owner: wmlclient
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
-- Name: ISOMetadata_MetadataID_seq; Type: SEQUENCE; Schema: public; Owner: wmlclient
--

CREATE SEQUENCE public."ISOMetadata_MetadataID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."ISOMetadata_MetadataID_seq" OWNER TO wmlclient;

--
-- Name: ISOMetadata_MetadataID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmlclient
--

ALTER SEQUENCE public."ISOMetadata_MetadataID_seq" OWNED BY public."ISOMetadata"."MetadataID";


--
-- Name: LabMethods; Type: TABLE; Schema: public; Owner: wmlclient
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
-- Name: LabMethods_LabMethodID_seq; Type: SEQUENCE; Schema: public; Owner: wmlclient
--

CREATE SEQUENCE public."LabMethods_LabMethodID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."LabMethods_LabMethodID_seq" OWNER TO wmlclient;

--
-- Name: LabMethods_LabMethodID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmlclient
--

ALTER SEQUENCE public."LabMethods_LabMethodID_seq" OWNED BY public."LabMethods"."LabMethodID";


--
-- Name: Methods; Type: TABLE; Schema: public; Owner: wmlclient
--

CREATE TABLE public."Methods" (
    "MethodID" integer NOT NULL,
    "MethodDescription" text NOT NULL,
    "MethodLink" text,
    "MethodCode" character varying(255) NOT NULL
);


ALTER TABLE public."Methods" OWNER TO wmlclient;

--
-- Name: Methods_MethodID_seq; Type: SEQUENCE; Schema: public; Owner: wmlclient
--

CREATE SEQUENCE public."Methods_MethodID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Methods_MethodID_seq" OWNER TO wmlclient;

--
-- Name: Methods_MethodID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmlclient
--

ALTER SEQUENCE public."Methods_MethodID_seq" OWNED BY public."Methods"."MethodID";


--
-- Name: ODMVersion; Type: TABLE; Schema: public; Owner: wmlclient
--

CREATE TABLE public."ODMVersion" (
    "VersionNumber" character varying(50) NOT NULL
);


ALTER TABLE public."ODMVersion" OWNER TO wmlclient;

--
-- Name: OffsetTypes; Type: TABLE; Schema: public; Owner: wmlclient
--

CREATE TABLE public."OffsetTypes" (
    "OffsetTypeID" integer NOT NULL,
    "OffsetUnitsID" integer NOT NULL,
    "OffsetDescription" text NOT NULL
);


ALTER TABLE public."OffsetTypes" OWNER TO wmlclient;

--
-- Name: OffsetTypes_OffsetTypeID_seq; Type: SEQUENCE; Schema: public; Owner: wmlclient
--

CREATE SEQUENCE public."OffsetTypes_OffsetTypeID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."OffsetTypes_OffsetTypeID_seq" OWNER TO wmlclient;

--
-- Name: OffsetTypes_OffsetTypeID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmlclient
--

ALTER SEQUENCE public."OffsetTypes_OffsetTypeID_seq" OWNED BY public."OffsetTypes"."OffsetTypeID";


--
-- Name: Qualifiers; Type: TABLE; Schema: public; Owner: wmlclient
--

CREATE TABLE public."Qualifiers" (
    "QualifierID" integer NOT NULL,
    "QualifierCode" character varying(50) DEFAULT NULL::character varying,
    "QualifierDescription" text NOT NULL
);


ALTER TABLE public."Qualifiers" OWNER TO wmlclient;

--
-- Name: Qualifiers_QualifierID_seq; Type: SEQUENCE; Schema: public; Owner: wmlclient
--

CREATE SEQUENCE public."Qualifiers_QualifierID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Qualifiers_QualifierID_seq" OWNER TO wmlclient;

--
-- Name: Qualifiers_QualifierID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmlclient
--

ALTER SEQUENCE public."Qualifiers_QualifierID_seq" OWNED BY public."Qualifiers"."QualifierID";


--
-- Name: QualityControlLevels; Type: TABLE; Schema: public; Owner: wmlclient
--

CREATE TABLE public."QualityControlLevels" (
    "QualityControlLevelID" integer NOT NULL,
    "QualityControlLevelCode" character varying(50) NOT NULL,
    "Definition" character varying(255) NOT NULL,
    "Explanation" text NOT NULL
);


ALTER TABLE public."QualityControlLevels" OWNER TO wmlclient;

--
-- Name: QualityControlLevels_QualityControlLevelID_seq; Type: SEQUENCE; Schema: public; Owner: wmlclient
--

CREATE SEQUENCE public."QualityControlLevels_QualityControlLevelID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."QualityControlLevels_QualityControlLevelID_seq" OWNER TO wmlclient;

--
-- Name: QualityControlLevels_QualityControlLevelID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmlclient
--

ALTER SEQUENCE public."QualityControlLevels_QualityControlLevelID_seq" OWNED BY public."QualityControlLevels"."QualityControlLevelID";


--
-- Name: SampleMediumCV; Type: TABLE; Schema: public; Owner: wmlclient
--

CREATE TABLE public."SampleMediumCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."SampleMediumCV" OWNER TO wmlclient;

--
-- Name: SampleTypeCV; Type: TABLE; Schema: public; Owner: wmlclient
--

CREATE TABLE public."SampleTypeCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."SampleTypeCV" OWNER TO wmlclient;

--
-- Name: Samples; Type: TABLE; Schema: public; Owner: wmlclient
--

CREATE TABLE public."Samples" (
    "SampleID" integer NOT NULL,
    "SampleType" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "LabSampleCode" character varying(50) NOT NULL,
    "LabMethodID" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."Samples" OWNER TO wmlclient;

--
-- Name: Samples_SampleID_seq; Type: SEQUENCE; Schema: public; Owner: wmlclient
--

CREATE SEQUENCE public."Samples_SampleID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Samples_SampleID_seq" OWNER TO wmlclient;

--
-- Name: Samples_SampleID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmlclient
--

ALTER SEQUENCE public."Samples_SampleID_seq" OWNED BY public."Samples"."SampleID";


--
-- Name: SeriesCatalog; Type: TABLE; Schema: public; Owner: wmlclient
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
-- Name: Sites; Type: TABLE; Schema: public; Owner: wmlclient
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
-- Name: Sources; Type: TABLE; Schema: public; Owner: wmlclient
--

CREATE TABLE public."Sources" (
    "SourceID" integer NOT NULL,
    "Organization" character varying(255) NOT NULL,
    "SourceDescription" text NOT NULL,
    "SourceLink" text,
    "ContactName" character varying(255) DEFAULT 'Unknown'::character varying,
    "Phone" character varying(255) DEFAULT 'Unknown'::character varying,
    "Email" character varying(255) DEFAULT 'Unknown'::character varying,
    "Address" character varying(255) DEFAULT 'Unknown'::character varying,
    "City" character varying(255) DEFAULT 'Unknown'::character varying,
    "State" character varying(255) DEFAULT 'Unknown'::character varying,
    "ZipCode" character varying(255) DEFAULT 'Unknown'::character varying,
    "Citation" text,
    "MetadataID" integer DEFAULT 0,
    "SourceCode" character varying
);


ALTER TABLE public."Sources" OWNER TO wmlclient;

--
-- Name: Units; Type: TABLE; Schema: public; Owner: wmlclient
--

CREATE TABLE public."Units" (
    "UnitsID" integer NOT NULL,
    "UnitsName" character varying(255) NOT NULL,
    "UnitsType" character varying(255) NOT NULL,
    "UnitsAbbreviation" character varying(255) NOT NULL
);


ALTER TABLE public."Units" OWNER TO wmlclient;

--
-- Name: Variables; Type: TABLE; Schema: public; Owner: wmlclient
--

CREATE TABLE public."Variables" (
    "VariableID" integer NOT NULL,
    "VariableCode" character varying(50) NOT NULL,
    "VariableName" character varying(255) NOT NULL,
    "Speciation" character varying(255) DEFAULT 'Not Applicable'::character varying,
    "VariableUnitsID" integer NOT NULL,
    "SampleMedium" character varying(255) DEFAULT 'Unknown'::character varying,
    "ValueType" character varying(255) DEFAULT 'Unknown'::character varying,
    "IsRegular" boolean DEFAULT false,
    "TimeSupport" real DEFAULT 0,
    "TimeUnitsID" integer DEFAULT 0,
    "DataType" character varying(255) DEFAULT 'Unknown'::character varying,
    "GeneralCategory" character varying(255) DEFAULT 'Unknown'::character varying,
    "NoDataValue" real DEFAULT 0
);


ALTER TABLE public."Variables" OWNER TO wmlclient;

--
-- Name: SeriesCatalogView; Type: MATERIALIZED VIEW; Schema: public; Owner: wmlclient
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
-- Name: UnitsXML; Type: VIEW; Schema: public; Owner: wmlclient
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
-- Name: VariableInfoXML; Type: VIEW; Schema: public; Owner: wmlclient
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
-- Name: SeriesCatalogXML; Type: VIEW; Schema: public; Owner: wmlclient
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
-- Name: SeriesCatalogXMLcombinada; Type: VIEW; Schema: public; Owner: wmlclient
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
-- Name: SeriesCatalog_SeriesID_seq; Type: SEQUENCE; Schema: public; Owner: wmlclient
--

CREATE SEQUENCE public."SeriesCatalog_SeriesID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."SeriesCatalog_SeriesID_seq" OWNER TO wmlclient;

--
-- Name: SeriesCatalog_SeriesID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmlclient
--

ALTER SEQUENCE public."SeriesCatalog_SeriesID_seq" OWNED BY public."SeriesCatalog"."SeriesID";


--
-- Name: SiteInfoXML; Type: VIEW; Schema: public; Owner: wmlclient
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
-- Name: SiteTypeCV; Type: TABLE; Schema: public; Owner: wmlclient
--

CREATE TABLE public."SiteTypeCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."SiteTypeCV" OWNER TO wmlclient;

--
-- Name: SitesWithSeriesCatalogXML; Type: VIEW; Schema: public; Owner: wmlclient
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
-- Name: Sites_SiteID_seq; Type: SEQUENCE; Schema: public; Owner: wmlclient
--

CREATE SEQUENCE public."Sites_SiteID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Sites_SiteID_seq" OWNER TO wmlclient;

--
-- Name: Sites_SiteID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmlclient
--

ALTER SEQUENCE public."Sites_SiteID_seq" OWNED BY public."Sites"."SiteID";


--
-- Name: SourceInfoXML; Type: VIEW; Schema: public; Owner: wmlclient
--

CREATE VIEW public."SourceInfoXML" AS
 SELECT "Sources"."SourceID",
    XMLELEMENT(NAME "sr:source", XMLELEMENT(NAME "sourceID", XMLATTRIBUTES(true AS "default", "Sources"."SourceID" AS "SourceID"), "Sources"."SourceID"), XMLELEMENT(NAME "Organization", "Sources"."Organization"), XMLELEMENT(NAME "SourceDescription", "Sources"."SourceDescription"), XMLELEMENT(NAME "SourceLink", "Sources"."SourceLink")) AS "SourceInfoXML"
   FROM public."Sources";


ALTER TABLE public."SourceInfoXML" OWNER TO wmlclient;

--
-- Name: Sources_SourceID_seq; Type: SEQUENCE; Schema: public; Owner: wmlclient
--

CREATE SEQUENCE public."Sources_SourceID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Sources_SourceID_seq" OWNER TO wmlclient;

--
-- Name: Sources_SourceID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmlclient
--

ALTER SEQUENCE public."Sources_SourceID_seq" OWNED BY public."Sources"."SourceID";


--
-- Name: SpatialReferences; Type: TABLE; Schema: public; Owner: wmlclient
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
-- Name: SpatialReferences_SpatialReferenceID_seq; Type: SEQUENCE; Schema: public; Owner: wmlclient
--

CREATE SEQUENCE public."SpatialReferences_SpatialReferenceID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."SpatialReferences_SpatialReferenceID_seq" OWNER TO wmlclient;

--
-- Name: SpatialReferences_SpatialReferenceID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmlclient
--

ALTER SEQUENCE public."SpatialReferences_SpatialReferenceID_seq" OWNED BY public."SpatialReferences"."SpatialReferenceID";


--
-- Name: SpeciationCV; Type: TABLE; Schema: public; Owner: wmlclient
--

CREATE TABLE public."SpeciationCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."SpeciationCV" OWNER TO wmlclient;

--
-- Name: TopicCategoryCV; Type: TABLE; Schema: public; Owner: wmlclient
--

CREATE TABLE public."TopicCategoryCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."TopicCategoryCV" OWNER TO wmlclient;

--
-- Name: Units_UnitsID_seq; Type: SEQUENCE; Schema: public; Owner: wmlclient
--

CREATE SEQUENCE public."Units_UnitsID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Units_UnitsID_seq" OWNER TO wmlclient;

--
-- Name: Units_UnitsID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmlclient
--

ALTER SEQUENCE public."Units_UnitsID_seq" OWNED BY public."Units"."UnitsID";


--
-- Name: ValueTypeCV; Type: TABLE; Schema: public; Owner: wmlclient
--

CREATE TABLE public."ValueTypeCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."ValueTypeCV" OWNER TO wmlclient;

--
-- Name: ValuesXML; Type: VIEW; Schema: public; Owner: wmlclient
--

CREATE VIEW public."ValuesXML" AS
 SELECT "DataValues"."ValueID",
    XMLELEMENT(NAME "sr:value", XMLATTRIBUTES("DataValues"."LocalDateTime" AS "dateTime", "DataValues"."DateTimeUTC" AS "dateTimeUTC", "DataValues"."MethodID" AS "methodID", "DataValues"."SourceID" AS "sourceID", "DataValues"."SampleID" AS "sampleID", "DataValues"."ValueID" AS oid, "DataValues"."UTCOffset" AS "timeOffset"), "DataValues"."DataValue") AS "ValueXML"
   FROM public."DataValues";


ALTER TABLE public."ValuesXML" OWNER TO wmlclient;

--
-- Name: VariableNameCV; Type: TABLE; Schema: public; Owner: wmlclient
--

CREATE TABLE public."VariableNameCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."VariableNameCV" OWNER TO wmlclient;

--
-- Name: Variables_VariableID_seq; Type: SEQUENCE; Schema: public; Owner: wmlclient
--

CREATE SEQUENCE public."Variables_VariableID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Variables_VariableID_seq" OWNER TO wmlclient;

--
-- Name: Variables_VariableID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wmlclient
--

ALTER SEQUENCE public."Variables_VariableID_seq" OWNED BY public."Variables"."VariableID";


--
-- Name: VerticalDatumCV; Type: TABLE; Schema: public; Owner: wmlclient
--

CREATE TABLE public."VerticalDatumCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."VerticalDatumCV" OWNER TO wmlclient;

--
-- Name: series_catalog_w_geom; Type: TABLE; Schema: public; Owner: wmlclient
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
-- Name: FeatureTypeCV FeatureTypeID; Type: DEFAULT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."FeatureTypeCV" ALTER COLUMN "FeatureTypeID" SET DEFAULT nextval('public."FeatureTypeCV_FeatureTypeID_seq"'::regclass);


--
-- Name: GroupDescriptions GroupID; Type: DEFAULT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."GroupDescriptions" ALTER COLUMN "GroupID" SET DEFAULT nextval('public."GroupDescriptions_GroupID_seq"'::regclass);


--
-- Name: ISOMetadata MetadataID; Type: DEFAULT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."ISOMetadata" ALTER COLUMN "MetadataID" SET DEFAULT nextval('public."ISOMetadata_MetadataID_seq"'::regclass);


--
-- Name: LabMethods LabMethodID; Type: DEFAULT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."LabMethods" ALTER COLUMN "LabMethodID" SET DEFAULT nextval('public."LabMethods_LabMethodID_seq"'::regclass);


--
-- Name: Methods MethodID; Type: DEFAULT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Methods" ALTER COLUMN "MethodID" SET DEFAULT nextval('public."Methods_MethodID_seq"'::regclass);


--
-- Name: OffsetTypes OffsetTypeID; Type: DEFAULT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."OffsetTypes" ALTER COLUMN "OffsetTypeID" SET DEFAULT nextval('public."OffsetTypes_OffsetTypeID_seq"'::regclass);


--
-- Name: Qualifiers QualifierID; Type: DEFAULT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Qualifiers" ALTER COLUMN "QualifierID" SET DEFAULT nextval('public."Qualifiers_QualifierID_seq"'::regclass);


--
-- Name: QualityControlLevels QualityControlLevelID; Type: DEFAULT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."QualityControlLevels" ALTER COLUMN "QualityControlLevelID" SET DEFAULT nextval('public."QualityControlLevels_QualityControlLevelID_seq"'::regclass);


--
-- Name: Samples SampleID; Type: DEFAULT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Samples" ALTER COLUMN "SampleID" SET DEFAULT nextval('public."Samples_SampleID_seq"'::regclass);


--
-- Name: SeriesCatalog SeriesID; Type: DEFAULT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."SeriesCatalog" ALTER COLUMN "SeriesID" SET DEFAULT nextval('public."SeriesCatalog_SeriesID_seq"'::regclass);


--
-- Name: Sites SiteID; Type: DEFAULT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Sites" ALTER COLUMN "SiteID" SET DEFAULT nextval('public."Sites_SiteID_seq"'::regclass);


--
-- Name: Sources SourceID; Type: DEFAULT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Sources" ALTER COLUMN "SourceID" SET DEFAULT nextval('public."Sources_SourceID_seq"'::regclass);


--
-- Name: SpatialReferences SpatialReferenceID; Type: DEFAULT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."SpatialReferences" ALTER COLUMN "SpatialReferenceID" SET DEFAULT nextval('public."SpatialReferences_SpatialReferenceID_seq"'::regclass);


--
-- Name: Units UnitsID; Type: DEFAULT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Units" ALTER COLUMN "UnitsID" SET DEFAULT nextval('public."Units_UnitsID_seq"'::regclass);


--
-- Name: Variables VariableID; Type: DEFAULT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Variables" ALTER COLUMN "VariableID" SET DEFAULT nextval('public."Variables_VariableID_seq"'::regclass);


--
-- Data for Name: Categories; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."Categories" ("VariableID", "DataValue", "CategoryDescription") FROM stdin;
\.


--
-- Data for Name: CensorCodeCV; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."CensorCodeCV" ("Term", "Definition") FROM stdin;
gt	greater than
lt	less than
nc	not censored
nd	non-detect
pnq	present but not quantified
\.


--
-- Data for Name: DataTypeCV; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."DataTypeCV" ("Term", "Definition") FROM stdin;
Average	The values represent the average over a time interval, such as daily mean discharge or daily mean temperature.
Best Easy Systematic Estimator	Best Easy Systematic Estimator BES = (Q1 +2Q2 +Q3)/4.  Q1, Q2, and Q3 are first, second, and third quartiles. See Woodcock, F. and Engel, C., 2005: Operational Consensus Forecasts.Weather and Forecasting, 20, 101-111. (http://www.bom.gov.au/nmoc/bulletins/60/article_by_Woodcock_in_Weather_and_Forecasting.pdf) and Wonnacott, T. H., and R. J. Wonnacott, 1972: Introductory Statistics. Wiley, 510 pp.
Categorical	The values are categorical rather than continuous valued quantities. Mapping from Value values to categories is through the CategoryDefinitions table.
Constant Over Interval	The values are quantities that can be interpreted as constant for all time, or over the time interval to a subsequent measurement of the same variable at the same site.
Continuous	A quantity specified at a particular instant in time measured with sufficient frequency (small spacing) to be interpreted as a continuous record of the phenomenon.
Cumulative	The values represent the cumulative value of a variable measured or calculated up to a given instant of time, such as cumulative volume of flow or cumulative precipitation.
Incremental	The values represent the incremental value of a variable over a time interval, such as the incremental volume of flow or incremental precipitation.
Maximum	The values are the maximum values occurring at some time during a time interval, such as annual maximum discharge or a daily maximum air temperature.
Median	The values represent the median over a time interval, such as daily median discharge or daily median temperature.
Minimum	The values are the minimum values occurring at some time during a time interval, such as 7-day low flow for a year or the daily minimum temperature.
Mode	The values are the most frequent values occurring at some time during a time interval, such as annual most frequent wind direction.
Sporadic	The phenomenon is sampled at a particular instant in time but with a frequency that is too coarse for interpreting the record as continuous.  This would be the case when the spacing is significantly larger than the support and the time scale of fluctuation of the phenomenon, such as for example infrequent water quality samples.
StandardDeviation	The values represent the standard deviation of a set of observations made over a time interval. Standard deviation computed using the unbiased formula SQRT(SUM((Xi-mean)^2)/(n-1)) are preferred. The specific formula used to compute variance can be noted in the methods description.
Unknown	The data type is unknown
Variance	The values represent the variance of a set of observations made over a time interval.  Variance computed using the unbiased formula SUM((Xi-mean)^2)/(n-1) are preferred.  The specific formula used to compute variance can be noted in the methods description.
\.


--
-- Data for Name: DataValues; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."DataValues" ("ValueID", "DataValue", "ValueAccuracy", "LocalDateTime", "UTCOffset", "DateTimeUTC", "SiteID", "VariableID", "OffsetValue", "OffsetTypeID", "CensorCode", "QualifierID", "MethodID", "SourceID", "SampleID", "DerivedFromID", "QualityControlLevelID") FROM stdin;
\.


--
-- Name: DataValues_ValueID_seq; Type: SEQUENCE SET; Schema: public; Owner: wmlclient
--

SELECT pg_catalog.setval('public."DataValues_ValueID_seq"', 1, false);


--
-- Data for Name: DerivedFrom; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."DerivedFrom" ("DerivedFromID", "ValueID") FROM stdin;
\.


--
-- Data for Name: FeatureTypeCV; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."FeatureTypeCV" ("FeatureTypeID", "FeatureTypeName", "Description") FROM stdin;
0	point	A point
1	polygon	A polygon
2	line	A line
\.


--
-- Name: FeatureTypeCV_FeatureTypeID_seq; Type: SEQUENCE SET; Schema: public; Owner: wmlclient
--

SELECT pg_catalog.setval('public."FeatureTypeCV_FeatureTypeID_seq"', 1, false);


--
-- Data for Name: GeneralCategoryCV; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."GeneralCategoryCV" ("Term", "Definition") FROM stdin;
Biota	Data associated with biological organisms
Climate	Data associated with the climate, weather, or atmospheric processes
Geology	Data associated with geology or geological processes
Hydrology	Data associated with hydrologic variables or processes
Instrumentation	Data associated with instrumentation and instrument properties such as battery voltages, data logger temperatures, often useful for diagnosis.
Unknown	The general category is unknown
Water Quality	Data associated with water quality variables or processes
\.


--
-- Data for Name: GroupDescriptions; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."GroupDescriptions" ("GroupID", "GroupDescription") FROM stdin;
\.


--
-- Name: GroupDescriptions_GroupID_seq; Type: SEQUENCE SET; Schema: public; Owner: wmlclient
--

SELECT pg_catalog.setval('public."GroupDescriptions_GroupID_seq"', 1, false);


--
-- Data for Name: Groups; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."Groups" ("GroupID", "ValueID") FROM stdin;
\.


--
-- Data for Name: ISOMetadata; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."ISOMetadata" ("MetadataID", "TopicCategory", "Title", "Abstract", "ProfileVersion", "MetadataLink") FROM stdin;
0	Unknown	Unknown	Unknown	Unknown	\N
\.


--
-- Name: ISOMetadata_MetadataID_seq; Type: SEQUENCE SET; Schema: public; Owner: wmlclient
--

SELECT pg_catalog.setval('public."ISOMetadata_MetadataID_seq"', 1, false);


--
-- Data for Name: LabMethods; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."LabMethods" ("LabMethodID", "LabName", "LabOrganization", "LabMethodName", "LabMethodDescription", "LabMethodLink") FROM stdin;
0	Unknown	Unknown	Unknown	Unknown	\N
\.


--
-- Name: LabMethods_LabMethodID_seq; Type: SEQUENCE SET; Schema: public; Owner: wmlclient
--

SELECT pg_catalog.setval('public."LabMethods_LabMethodID_seq"', 1, false);


--
-- Data for Name: Methods; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."Methods" ("MethodID", "MethodDescription", "MethodLink", "MethodCode") FROM stdin;
\.


--
-- Name: Methods_MethodID_seq; Type: SEQUENCE SET; Schema: public; Owner: wmlclient
--

SELECT pg_catalog.setval('public."Methods_MethodID_seq"', 1, false);


--
-- Data for Name: ODMVersion; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."ODMVersion" ("VersionNumber") FROM stdin;
1.1.1
1.1.1
1.1.1
1.1.1
\.


--
-- Data for Name: OffsetTypes; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."OffsetTypes" ("OffsetTypeID", "OffsetUnitsID", "OffsetDescription") FROM stdin;
\.


--
-- Name: OffsetTypes_OffsetTypeID_seq; Type: SEQUENCE SET; Schema: public; Owner: wmlclient
--

SELECT pg_catalog.setval('public."OffsetTypes_OffsetTypeID_seq"', 1, false);


--
-- Data for Name: Qualifiers; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."Qualifiers" ("QualifierID", "QualifierCode", "QualifierDescription") FROM stdin;
\.


--
-- Name: Qualifiers_QualifierID_seq; Type: SEQUENCE SET; Schema: public; Owner: wmlclient
--

SELECT pg_catalog.setval('public."Qualifiers_QualifierID_seq"', 1, false);


--
-- Data for Name: QualityControlLevels; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."QualityControlLevels" ("QualityControlLevelID", "QualityControlLevelCode", "Definition", "Explanation") FROM stdin;
-9999	-9999	Unknown	The quality control level is unknown
0	0	Raw data	Raw and unprocessed data and data products that have not undergone quality control.  Depending on the variable, data type, and data transmission system, raw data may be available within seconds or minutes after the measurements have been made. Examples include real time precipitation, streamflow and water quality measurements.
1	1	Quality controlled data	Quality controlled data that have passed quality assurance procedures such as routine estimation of timing and sensor calibration or visual inspection and removal of obvious errors. An example is USGS published streamflow records following parsing through USGS quality control procedures.
2	2	Derived products	Derived products that require scientific and technical interpretation and may include multiple-sensor data. An example is basin average precipitation derived from rain gages using an interpolation procedure.
3	3	Interpreted products	Interpreted products that require researcher driven analysis and interpretation, model-based interpretation using other data and/or strong prior assumptions. An example is basin average precipitation derived from the combination of rain gages and radar return data.
4	4	Knowledge products	Knowledge products that require researcher driven scientific interpretation and multidisciplinary data integration and include model-based interpretation using other data and/or strong prior assumptions. An example is percentages of old or new water in a hydrograph inferred from an isotope analysis.
\.


--
-- Name: QualityControlLevels_QualityControlLevelID_seq; Type: SEQUENCE SET; Schema: public; Owner: wmlclient
--

SELECT pg_catalog.setval('public."QualityControlLevels_QualityControlLevelID_seq"', 1, false);


--
-- Data for Name: SampleMediumCV; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."SampleMediumCV" ("Term", "Definition") FROM stdin;
Air	Sample taken from the atmosphere
Flowback water	A mixture of formation water and hydraulic fracturing injectates deriving from oil and gas wells prior to placing wells into production
Groundwater	Sample taken from water located below the surface of the ground, such as from a well or spring
Municipal waste water	Sample taken from raw municipal waste water stream.
Not Relevant	Sample medium not relevant in the context of the measurement
Other	Sample medium other than those contained in the CV
Precipitation	Sample taken from solid or liquid precipitation
Production water	Fluids produced from wells during oil or gas production which may include formation water, injected fluids, oil and gas.
Sediment	Sample taken from the sediment beneath the water column
Snow	Observation in, of or sample taken from snow
Soil	Sample taken from the soil
Soil air	Air contained in the soil pores
Soil water	the water contained in the soil pores
Surface Water	Observation or sample of surface water such as a stream, river, lake, pond, reservoir, ocean, etc.
Tissue	Sample taken from the tissue of a biological organism
Unknown	The sample medium is unknown
\.


--
-- Data for Name: SampleTypeCV; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."SampleTypeCV" ("Term", "Definition") FROM stdin;
Automated	Sample collected using an automated sampler
FD 	 Foliage Digestion
FF 	 Forest Floor Digestion
FL 	 Foliage Leaching
Grab	Grab sample
GW 	 Groundwater
LF 	 Litter Fall Digestion
meteorological	sample type can include a number of measured sample types including temperature, RH, solar radiation, precipitation, wind speed, wind direction.
No Sample	There is no lab sample associated with this measurement
PB  	 Precipitation Bulk
PD 	 Petri Dish (Dry Deposition)
PE 	 Precipitation Event
PI 	 Precipitation Increment
PW 	 Precipitation Weekly
RE 	 Rock Extraction
SE 	 Stemflow Event
SR 	 Standard Reference
SS 	Streamwater Suspended Sediment
SW 	 Streamwater
TE 	 Throughfall Event
TI 	 Throughfall Increment
TW 	 Throughfall Weekly
Unknown	The sample type is unknown
VE 	 Vadose Water Event
VI 	 Vadose Water Increment
VW 	 Vadose Water Weekly
\.


--
-- Data for Name: Samples; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."Samples" ("SampleID", "SampleType", "LabSampleCode", "LabMethodID") FROM stdin;
\.


--
-- Name: Samples_SampleID_seq; Type: SEQUENCE SET; Schema: public; Owner: wmlclient
--

SELECT pg_catalog.setval('public."Samples_SampleID_seq"', 1, false);


--
-- Data for Name: SeriesCatalog; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."SeriesCatalog" ("SeriesID", "SiteID", "SiteCode", "SiteName", "SiteType", "VariableID", "VariableCode", "VariableName", "Speciation", "VariableUnitsID", "VariableUnitsName", "SampleMedium", "ValueType", "TimeSupport", "TimeUnitsID", "TimeUnitsName", "DataType", "GeneralCategory", "MethodID", "MethodDescription", "SourceID", "Organization", "SourceDescription", "Citation", "QualityControlLevelID", "QualityControlLevelCode", "BeginDateTime", "EndDateTime", "BeginDateTimeUTC", "EndDateTimeUTC", "ValueCount") FROM stdin;
\.


--
-- Name: SeriesCatalog_SeriesID_seq; Type: SEQUENCE SET; Schema: public; Owner: wmlclient
--

SELECT pg_catalog.setval('public."SeriesCatalog_SeriesID_seq"', 1, false);


--
-- Data for Name: SiteTypeCV; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."SiteTypeCV" ("Term", "Definition") FROM stdin;
Aggregate groundwater use	An Aggregate Groundwater Withdrawal/Return site represents an aggregate of specific sites whe groundwater is withdrawn or returned which is defined by a geographic area or some other common characteristic. An aggregate groundwatergroundwater site type is used when it is not possible or practical to describe the specific sites as springs or as any type of well including 'multiple wells', or when water-use information is only available for the aggregate. Aggregate sites that span multiple counties should be coded with 000 as the county code, or an aggregate site can be created for each county.
Aggregate surface-water-use	An Aggregate Surface-Water Diversion/Return site represents an aggregate of specific sites where surface water is diverted or returned which is defined by a geographic area or some other common characteristic. An aggregate surface-water site type is used when it is not possible or practical to describe the specific sites as diversions, outfalls, or land application sites, or when water-use information is only available for the aggregate. Aggregate sites that span multiple counties should be coded with 000 as the county code, or an aggregate site can be created for each county.
Aggregate water-use establishment	An Aggregate Water-Use Establishment represents an aggregate class of water-using establishments or individuals that are associated with a specific geographic location and water-use category, such as all the industrial users located within a county or all self-supplied domestic users in a county. The aggregate class of water-using establishments is identified using the national water-use category code and optionally classified using the Standard Industrial Classification System Code (SIC code) or North American Classification System Code (NAICS code). An aggregate water-use establishment site type is used when specific information needed to create sites for the individual facilities or users is not available or when it is not desirable to store the site-specific information in the database. Data entry rules that apply to water-use establishments also apply to aggregate water-use establishments. Aggregate sites that span multiple counties should be coded with 000 as the county code, or an aggregate site can be created for each county.
Animal waste lagoon	A facility for storage and/or biological treatment of wastes from livestock operations. Animal-waste lagoons are earthen structures ranging from pits to large ponds, and contain manure which has been diluted with building washwater, rainfall, and surface runoff. In treatment lagoons, the waste becomes partially liquefied and stabilized by bacterial action before the waste is disposed of on the land and the water is discharged or re-used.
Atmosphere	A site established primarily to measure meteorological properties or atmospheric deposition.
Canal	An artificial watercourse designed for navigation, drainage, or irrigation by connecting two or more bodies of water; it is larger than a ditch.
Cave	A natural open space within a rock formation large enough to accommodate a human. A cave may have an opening to the outside, is always underground, and sometimes submerged. Caves commonly occur by the dissolution of soluble rocks, generally limestone, but may also be created within the voids of large-rock aggregations, in openings along seismic faults, and in lava formations.
Cistern	An artificial, non-pressurized reservoir filled by gravity flow and used for water storage. The reservoir may be located above, at, or below ground level. The water may be supplied from diversion of precipitation, surface, or groundwater sources.
Coastal	An oceanic site that is located off-shore beyond the tidal mixing zone (estuary) but close enough to the shore that the investigator considers the presence of the coast to be important. Coastal sites typically are within three nautical miles of the shore.
Collector or Ranney type well	An infiltration gallery consisting of one or more underground laterals through which groundwater is collected and a vertical caisson from which groundwater is removed. Also known as a \\"horizontal well\\". These wells produce large yield with small drawdown.
Combined sewer	An underground conduit created to convey storm drainage and waste products into a wastewater-treatment plant, stream, reservoir, or disposal site.
Ditch	An excavation artificially dug in the ground, either lined or unlined, for conveying water for drainage or irrigation; it is smaller than a canal.
Diversion	A site where water is withdrawn or diverted from a surface-water body (e.g. the point where the upstream end of a canal intersects a stream, or point where water is withdrawn from a reservoir). Includes sites where water is pumped for use elsewhere.
Estuary	A coastal inlet of the sea or ocean; esp. the mouth of a river, where tide water normally mixes with stream water (modified, Webster). Salinity in estuaries typically ranges from 1 to 25 Practical Salinity Units (psu), as compared oceanic values around 35-psu. See also: tidal stream and coastal.
Excavation	An artificially constructed cavity in the earth that is deeper than the soil (see soil hole), larger than a well bore (see well and test hole), and substantially open to the atmosphere. The diameter of an excavation is typically similar or larger than the depth. Excavations include building-foundation diggings, roadway cuts, and surface mines.
Extensometer well	A well equipped to measure small changes in the thickness of the penetrated sediments, such as those caused by groundwater withdrawal or recharge.
Facility	A non-ambient location where environmental measurements are expected to be strongly influenced by current or previous activities of humans. *Sites identified with a \\"facility\\" primary site type must be further classified with one of the applicable secondary site types.
Field, Pasture, Orchard, or Nursery	A water-using facility characterized by an area where plants are grown for transplanting, for use as stocks for budding and grafting, or for sale. Irrigation water may or may not be applied.
Glacier	Body of land ice that consists of recrystallized snow accumulated on the surface of the ground and moves slowly downslope (WSP-1541A) over a period of years or centuries. Since glacial sites move, the lat-long precision for these sites is usually coarse.
Golf course	A place-of-use, either public or private, where the game of golf is played. A golf course typically uses water for irrigation purposes. Should not be used if the site is a specific hydrologic feature or facility; but can be used especially for the water-use sites.
Groundwater drain	An underground pipe or tunnel through which groundwater is artificially diverted to surface water for the purpose of reducing erosion or lowering the water table. A drain is typically open to the atmosphere at the lowest elevation, in contrast to a well which is open at the highest point.
Hydroelectric plant	A facility that generates electric power by converting potential energy of water into kinetic energy. Typically, turbine generators are turned by falling water.
Hyporheic-zone well	A permanent well, drive point, or other device intended to sample a saturated zone in close proximity to a stream.
Interconnected wells	Collector or drainage wells connected by an underground lateral.
Laboratory or sample-preparation area	A site where some types of quality-control samples are collected, and where equipment and supplies for environmental sampling are prepared. Equipment blank samples are commonly collected at this site type, as are samples of locally produced deionized water. This site type is typically used when the data are either not associated with a unique environmental data-collection site, or where blank water supplies are designated by Center offices with unique station IDs.
Lake, Reservoir, Impoundment	An inland body of standing fresh or saline water that is generally too deep to permit submerged aquatic vegetation to take root across the entire body (cf: wetland). This site type includes an expanded part of a river, a reservoir behind a dam, and a natural or excavated depression containing a water body without surface-water inlet and/or outlet.
Land	A location on the surface of the earth that is not normally saturated with water. Land sites are appropriate for sampling vegetation, overland flow of water, or measuring land-surface properties such as temperature. (See also: Wetland).
Landfill	A typically dry location on the surface of the land where primarily solid waste products are currently, or previously have been, aggregated and sometimes covered with a veneer of soil. See also: Wastewater disposal and waste-injection well.
Multiple wells	A group of wells that are pumped through a single header and for which little or no data about the individual wells are available.
Ocean	Site in the open ocean, gulf, or sea. (See also: Coastal, Estuary, and Tidal stream).
Outcrop	The part of a rock formation that appears at the surface of the surrounding land.
Outfall	A site where water or wastewater is returned to a surface-water body, e.g. the point where wastewater is returned to a stream. Typically, the discharge end of an effluent pipe.
Pavement	A surface site where the land surface is covered by a relatively impermeable material, such as concrete or asphalt. Pavement sites are typically part of transportation infrastructure, such as roadways, parking lots, or runways.
Playa	A dried-up, vegetation-free, flat-floored area composed of thin, evenly stratified sheets of fine clay, silt or sand, and represents the bottom part of a shallow, completely closed or undrained desert lake basin in which water accumulates and is quickly evaporated, usually leaving deposits of soluble salts.
Septic system	A site within or in close proximity to a subsurface sewage disposal system that generally consists of: (1) a septic tank where settling of solid material occurs, (2) a distribution system that transfers fluid from the tank to (3) a leaching system that disperses the effluent into the ground.
Shore	The land along the edge of the sea, a lake, or a wide river where the investigator considers the proximity of the water body to be important. Land adjacent to a reservoir, lake, impoundment, or oceanic site type is considered part of the shore when it includes a beach or bank between the high and low water marks.
Sinkhole	A crater formed when the roof of a cavern collapses; usually found in limestone areas. Surface water and precipitation that enters a sinkhole usually evaporates or infiltrates into the ground, rather than draining into a stream.
Soil hole	A small excavation into soil at the top few meters of earth surface. Soil generally includes some organic matter derived from plants. Soil holes are created to measure soil composition and properties. Sometimes electronic probes are inserted into soil holes to measure physical properties, and (or) the extracted soil is analyzed.
Spring	A location at which the water table intersects the land surface, resulting in a natural flow of groundwater to the surface. Springs may be perennial, intermittent, or ephemeral.
Storm sewer	An underground conduit created to convey storm drainage into a stream channel or reservoir. If the sewer also conveys liquid waste products, then the \\"combined sewer\\" secondary site type should be used.
Stream	A body of running water moving under gravity flow in a defined channel. The channel may be entirely natural, or altered by engineering practices through straightening, dredging, and (or) lining. An entirely artificial channel should be qualified with the \\"canal\\" or \\"ditch\\" secondary site type.
Subsurface	A location below the land surface, but not a well, soil hole, or excavation.
Test hole not completed as a well	An uncased hole (or one cased only temporarily) that was drilled for water, or for geologic or hydrogeologic testing. It may be equipped temporarily with a pump in order to make a pumping test, but if the hole is destroyed after testing is completed, it is still a test hole. A core hole drilled as a part of mining or quarrying exploration work should be in this class.
Thermoelectric plant	A facility that uses water in the generation of electricity from heat. Typically turbine generators are driven by steam. The heat may be caused by various means, including combustion, nuclear reactions, and geothermal processes.
Tidal stream	A stream reach where the flow is influenced by the tide, but where the water chemistry is not normally influenced. A site where ocean water typically mixes with stream water should be coded as an estuary.
Tunnel, shaft, or mine	A constructed subsurface open space large enough to accommodate a human that is not substantially open to the atmosphere and is not a well. The excavation may have been for minerals, transportation, or other purposes. See also: Excavation.
Unsaturated zone	A site equipped to measure conditions in the subsurface deeper than a soil hole, but above the water table or other zone of saturation.
Volcanic vent	Vent from which volcanic gases escape to the atmosphere. Also known as fumarole.
Waste injection well	A facility used to convey industrial waste, domestic sewage, brine, mine drainage, radioactive waste, or other fluid into an underground zone. An oil-test or deep-water well converted to waste disposal should be in this category. A well where fresh water is injected to artificially recharge thegroundwaterr supply or to pressurize an oil or gas production zone by injecting a fluid should be classified as a well (not an injection-well facility), with additional information recorded under Use of Site.
Wastewater land application	A site where the disposal of waste water on land occurs. Use \\"waste-injection well\\" for underground waste-disposal sites.
Wastewater sewer	An underground conduit created to convey liquid and semisolid domestic, commercial, or industrial waste into a treatment plant, stream, reservoir, or disposal site. If the sewer also conveys storm water, then the \\"combined sewer\\" secondary site type should be used.
Wastewater-treatment plant	A facility where wastewater is treated to reduce concentrations of dissolved and (or) suspended materials prior to discharge or reuse.
Water-distribution system	A site located somewhere on a networked infrastructure that distributes treated or untreated water to multiple domestic, industrial, institutional, and (or) commercial users. May be owned by a municipality or community, a water district, or a private concern.
Water-supply treatment plant	A facility where water is treated prior to use for consumption or other purpose.
Water-use establishment	A place-of-use (a water using facility that is associated with a specific geographical point location, such as a business or industrial user) that cannot be specified with any other facility secondary type. Water-use place-of-use sites are establishments such as a factory, mill, store, warehouse, farm, ranch, or bank. A place-of-use site is further classified using the national water-use category code (C39) and optionally classified using the Standard Industrial Classification System Code (SIC code) or North American Classification System Code (NAICS code). See also: Aggregate water-use-establishment.
Well	A hole or shaft constructed in the earth intended to be used to locate, sample, or develop groundwater, oil, gas, or some other subsurface material. The diameter of a well is typically much smaller than the depth. Wells are also used to artificially recharge groundwater or to pressurize oil and gas production zones. Additional information about specific kinds of wells should be recorded under the secondary site types or the Use of Site field. Underground waste-disposal wells should be classified as waste-injection wells.
Wetland	Land where saturation with water is the dominant factor determining the nature of soil development and the types of plant and animal communities living in the soil and on its surface (Cowardin, December 1979). Wetlands are found from the tundra to the tropics and on every continent except Antarctica. Wetlands are areas that are inundated or saturated by surface or groundwater at a frequency and duration sufficient to support, and that under normal circumstances do support, a prevalence of vegetation typically adapted for life in saturated soil conditions. Wetlands generally include swamps, marshes, bogs and similar areas. Wetlands may be forested or unforested, and naturally or artificially created.
\.


--
-- Data for Name: Sites; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."Sites" ("SiteID", "SiteCode", "SiteName", "Latitude", "Longitude", "LatLongDatumID", "SiteType", "Elevation_m", "VerticalDatum", "LocalX", "LocalY", "LocalProjectionID", "PosAccuracy_m", "State", "County", "Comments", "Country", "Geometry", "FeatureType") FROM stdin;
25	5135ac9c-44c9-3bbe-b17f-e70ba6d8b0b0	Ladario	-19.0005436	-57.5955582	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E61000002367614F3BCC4CC0E23D0796230033C0	point
26	bef9f3d6-6042-3d8f-8386-56996365ca39	PORTO ESPERANA	-19.6005993	-57.4371986	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E6100000D5E76A2BF6B74CC044FAEDEBC09933C0	point
27	f19453ef-50c5-31ac-8e87-ffa7f722eaa8	LADRIO (BASE NAVAL)	-19.0016994	-57.5942001	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000040A4DFBE0ECC4CC0386744696F0033C0	point
28	f827784d-5941-3286-a26f-532a73033032	SO FRANCISCO	-18.3938999	-57.3911018	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000099BB96900FB24CC0F7E461A1D66432C0	point
29	0b78a220-3801-3f9c-bb33-8995b3f931f9	MIRANDA	-20.2408009	-56.3992004	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E6100000174850FC18334CC076E09C11A53D34C0	point
30	1544171c-7f59-31fa-b8a5-0cd6891108f5	BONITO	-21.246666	-56.4505539	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E61000000124E4CDAB394CC0ABB6D58B253F35C0	point
31	386f1110-c88d-366f-abe2-b5eb1a2e1f37	AQUIDAUANA	-20.4780998	-55.8013992	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E6100000D881734694E64BC0B537F8C2647A34C0	point
33	5a88efda-b5ea-3b71-a141-9c09ea0d2f98	PORTO MURTINHO	-21.7003002	-57.8911018	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000099BB96900FF24CC088635DDC46B335C0	point
34	6605c504-6f43-3532-a5d9-63783d237a8f	PALMEIRAS	-20.4480991	-55.4281006	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000074B515FBCBB64BC06D567DAEB67234C0	point
35	76f7208d-a8cb-3455-af3c-b7ab5b3ffc7c	ESTRADA MT-738	-20.7618999	-56.0910988	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E61000003255302AA90B4CC089D2DEE00BC334C0	point
\.


--
-- Name: Sites_SiteID_seq; Type: SEQUENCE SET; Schema: public; Owner: wmlclient
--

SELECT pg_catalog.setval('public."Sites_SiteID_seq"', 38, true);


--
-- Data for Name: Sources; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."Sources" ("SourceID", "Organization", "SourceDescription", "SourceLink", "ContactName", "Phone", "Email", "Address", "City", "State", "ZipCode", "Citation", "MetadataID", "SourceCode") FROM stdin;
39	National Metereology Institute of Brazil	author	\N	Unknown	Unknown	Unknown	Unknown	Unknown	Unknown	Unknown	Acquisitions at JUTI - Precipitation	0	0
50	National Metereology Institute of Brazil	author	\N	\N	\N	\N	\N	\N	\N	\N	Acquisitions at JUTI - Precipitation	\N	\N
51	National Metereology Institute of Brazil	author	\N	\N	\N	\N	\N	\N	\N	\N	Acquisitions at JUTI - Precipitation	\N	\N
52	National Metereology Institute of Brazil	author	\N	\N	\N	\N	\N	\N	\N	\N	Acquisitions at JUTI - Precipitation	\N	\N
53	National Metereology Institute of Brazil	author	\N	\N	\N	\N	\N	\N	\N	\N	Acquisitions at JUTI - Precipitation	\N	\N
\.


--
-- Name: Sources_SourceID_seq; Type: SEQUENCE SET; Schema: public; Owner: wmlclient
--

SELECT pg_catalog.setval('public."Sources_SourceID_seq"', 53, true);


--
-- Data for Name: SpatialReferences; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."SpatialReferences" ("SpatialReferenceID", "SRSID", "SRSName", "IsGeographic", "Notes") FROM stdin;
0	\N	Unknown	f	The spatial reference system is unknown
1	4267	NAD27	t	\N
2	4269	NAD83	t	\N
3	4326	WGS84	t	\N
4	26703	NAD27 / UTM zone 3N	f	\N
5	26704	NAD27 / UTM zone 4N	f	\N
6	26705	NAD27 / UTM zone 5N	f	\N
7	26706	NAD27 / UTM zone 6N	f	\N
8	26707	NAD27 / UTM zone 7N	f	\N
9	26708	NAD27 / UTM zone 8N	f	\N
10	26709	NAD27 / UTM zone 9N	f	\N
11	26710	NAD27 / UTM zone 10N	f	\N
12	26711	NAD27 / UTM zone 11N	f	\N
13	26712	NAD27 / UTM zone 12N	f	\N
14	26713	NAD27 / UTM zone 13N	f	\N
15	26714	NAD27 / UTM zone 14N	f	\N
16	26715	NAD27 / UTM zone 15N	f	\N
17	26716	NAD27 / UTM zone 16N	f	\N
18	26717	NAD27 / UTM zone 17N	f	\N
19	26718	NAD27 / UTM zone 18N	f	\N
20	26719	NAD27 / UTM zone 19N	f	\N
21	26720	NAD27 / UTM zone 20N	f	\N
22	26721	NAD27 / UTM zone 21N	f	\N
23	26722	NAD27 / UTM zone 22N	f	\N
24	26729	NAD27 / Alabama East	f	\N
25	26730	NAD27 / Alabama West	f	\N
26	26732	NAD27 / Alaska zone 2	f	\N
27	26733	NAD27 / Alaska zone 3	f	\N
28	26734	NAD27 / Alaska zone 4	f	\N
29	26735	NAD27 / Alaska zone 5	f	\N
30	26736	NAD27 / Alaska zone 6	f	\N
31	26737	NAD27 / Alaska zone 7	f	\N
32	26738	NAD27 / Alaska zone 8	f	\N
33	26739	NAD27 / Alaska zone 9	f	\N
34	26740	NAD27 / Alaska zone 10	f	\N
35	26741	NAD27 / California zone I	f	\N
36	26742	NAD27 / California zone II	f	\N
37	26743	NAD27 / California zone III	f	\N
38	26744	NAD27 / California zone IV	f	\N
39	26745	NAD27 / California zone V	f	\N
40	26746	NAD27 / California zone VI	f	\N
41	26747	NAD27 / California zone VII	f	\N
42	26748	NAD27 / Arizona East	f	\N
43	26749	NAD27 / Arizona Central	f	\N
44	26750	NAD27 / Arizona West	f	\N
45	26751	NAD27 / Arkansas North	f	\N
46	26752	NAD27 / Arkansas South	f	\N
47	26753	NAD27 / Colorado North	f	\N
48	26754	NAD27 / Colorado Central	f	\N
49	26755	NAD27 / Colorado South	f	\N
50	26756	NAD27 / Connecticut	f	\N
51	26757	NAD27 / Delaware	f	\N
52	26758	NAD27 / Florida East	f	\N
53	26759	NAD27 / Florida West	f	\N
54	26760	NAD27 / Florida North	f	\N
55	26761	NAD27 / Hawaii zone 1	f	\N
56	26762	NAD27 / Hawaii zone 2	f	\N
57	26763	NAD27 / Hawaii zone 3	f	\N
58	26764	NAD27 / Hawaii zone 4	f	\N
59	26765	NAD27 / Hawaii zone 5	f	\N
60	26766	NAD27 / Georgia East	f	\N
61	26767	NAD27 / Georgia West	f	\N
62	26768	NAD27 / Idaho East	f	\N
63	26769	NAD27 / Idaho Central	f	\N
64	26770	NAD27 / Idaho West	f	\N
65	26771	NAD27 / Illinois East	f	\N
66	26772	NAD27 / Illinois West	f	\N
67	26773	NAD27 / Indiana East	f	\N
68	26774	NAD27 / Indiana West	f	\N
69	26775	NAD27 / Iowa North	f	\N
70	26776	NAD27 / Iowa South	f	\N
71	26777	NAD27 / Kansas North	f	\N
72	26778	NAD27 / Kansas South	f	\N
73	26779	NAD27 / Kentucky North	f	\N
74	26780	NAD27 / Kentucky South	f	\N
75	26781	NAD27 / Louisiana North	f	\N
76	26782	NAD27 / Louisiana South	f	\N
77	26783	NAD27 / Maine East	f	\N
78	26784	NAD27 / Maine West	f	\N
79	26785	NAD27 / Maryland	f	\N
80	26786	NAD27 / Massachusetts Mainland	f	\N
81	26787	NAD27 / Massachusetts Island	f	\N
82	26791	NAD27 / Minnesota North	f	\N
83	26792	NAD27 / Minnesota Central	f	\N
84	26793	NAD27 / Minnesota South	f	\N
85	26794	NAD27 / Mississippi East	f	\N
86	26795	NAD27 / Mississippi West	f	\N
87	26796	NAD27 / Missouri East	f	\N
88	26797	NAD27 / Missouri Central	f	\N
89	26798	NAD27 / Missouri West	f	\N
90	26801	NAD Michigan / Michigan East	f	\N
91	26802	NAD Michigan / Michigan Old Central	f	\N
92	26803	NAD Michigan / Michigan West	f	\N
93	26811	NAD Michigan / Michigan North	f	\N
94	26812	NAD Michigan / Michigan Central	f	\N
95	26813	NAD Michigan / Michigan South	f	\N
96	26903	NAD83 / UTM zone 3N	f	\N
97	26904	NAD83 / UTM zone 4N	f	\N
98	26905	NAD83 / UTM zone 5N	f	\N
99	26906	NAD83 / UTM zone 6N	f	\N
100	26907	NAD83 / UTM zone 7N	f	\N
101	26908	NAD83 / UTM zone 8N	f	\N
102	26909	NAD83 / UTM zone 9N	f	\N
103	26910	NAD83 / UTM zone 10N	f	\N
104	26911	NAD83 / UTM zone 11N	f	\N
105	26912	NAD83 / UTM zone 12N	f	\N
106	26913	NAD83 / UTM zone 13N	f	\N
107	26914	NAD83 / UTM zone 14N	f	\N
108	26915	NAD83 / UTM zone 15N	f	\N
109	26916	NAD83 / UTM zone 16N	f	\N
110	26917	NAD83 / UTM zone 17N	f	\N
111	26918	NAD83 / UTM zone 18N	f	\N
112	26919	NAD83 / UTM zone 19N	f	\N
113	26920	NAD83 / UTM zone 20N	f	\N
114	26921	NAD83 / UTM zone 21N	f	\N
115	26922	NAD83 / UTM zone 22N	f	\N
116	26923	NAD83 / UTM zone 23N	f	\N
117	26929	NAD83 / Alabama East	f	\N
118	26930	NAD83 / Alabama West	f	\N
119	26932	NAD83 / Alaska zone 2	f	\N
120	26933	NAD83 / Alaska zone 3	f	\N
121	26934	NAD83 / Alaska zone 4	f	\N
122	26935	NAD83 / Alaska zone 5	f	\N
123	26936	NAD83 / Alaska zone 6	f	\N
124	26937	NAD83 / Alaska zone 7	f	\N
125	26938	NAD83 / Alaska zone 8	f	\N
126	26939	NAD83 / Alaska zone 9	f	\N
127	26940	NAD83 / Alaska zone 10	f	\N
128	26941	NAD83 / California zone 1	f	\N
129	26942	NAD83 / California zone 2	f	\N
130	26943	NAD83 / California zone 3	f	\N
131	26944	NAD83 / California zone 4	f	\N
132	26945	NAD83 / California zone 5	f	\N
133	26946	NAD83 / California zone 6	f	\N
134	26948	NAD83 / Arizona East	f	\N
135	26949	NAD83 / Arizona Central	f	\N
136	26950	NAD83 / Arizona West	f	\N
137	26951	NAD83 / Arkansas North	f	\N
138	26952	NAD83 / Arkansas South	f	\N
139	26953	NAD83 / Colorado North	f	\N
140	26954	NAD83 / Colorado Central	f	\N
141	26955	NAD83 / Colorado South	f	\N
142	26956	NAD83 / Connecticut	f	\N
143	26957	NAD83 / Delaware	f	\N
144	26958	NAD83 / Florida East	f	\N
145	26959	NAD83 / Florida West	f	\N
146	26960	NAD83 / Florida North	f	\N
147	26961	NAD83 / Hawaii zone 1	f	\N
148	26962	NAD83 / Hawaii zone 2	f	\N
149	26963	NAD83 / Hawaii zone 3	f	\N
150	26964	NAD83 / Hawaii zone 4	f	\N
151	26965	NAD83 / Hawaii zone 5	f	\N
152	26966	NAD83 / Georgia East	f	\N
153	26967	NAD83 / Georgia West	f	\N
154	26968	NAD83 / Idaho East	f	\N
155	26969	NAD83 / Idaho Central	f	\N
156	26970	NAD83 / Idaho West	f	\N
157	26971	NAD83 / Illinois East	f	\N
158	26972	NAD83 / Illinois West	f	\N
159	26973	NAD83 / Indiana East	f	\N
160	26974	NAD83 / Indiana West	f	\N
161	26975	NAD83 / Iowa North	f	\N
162	26976	NAD83 / Iowa South	f	\N
163	26977	NAD83 / Kansas North	f	\N
164	26978	NAD83 / Kansas South	f	\N
165	26979	NAD83 / Kentucky North	f	\N
166	26980	NAD83 / Kentucky South	f	\N
167	26981	NAD83 / Louisiana North	f	\N
168	26982	NAD83 / Louisiana South	f	\N
169	26983	NAD83 / Maine East	f	\N
170	26984	NAD83 / Maine West	f	\N
171	26985	NAD83 / Maryland	f	\N
172	26986	NAD83 / Massachusetts Mainland	f	\N
173	26987	NAD83 / Massachusetts Island	f	\N
174	26988	NAD83 / Michigan North	f	\N
175	26989	NAD83 / Michigan Central	f	\N
176	26990	NAD83 / Michigan South	f	\N
177	26991	NAD83 / Minnesota North	f	\N
178	26992	NAD83 / Minnesota Central	f	\N
179	26993	NAD83 / Minnesota South	f	\N
180	26994	NAD83 / Mississippi East	f	\N
181	26995	NAD83 / Mississippi West	f	\N
182	26996	NAD83 / Missouri East	f	\N
183	26997	NAD83 / Missouri Central	f	\N
184	26998	NAD83 / Missouri West  	f	\N
185	4176	Australian Antarctic	t	Datum Name: Australian Antarctic Datum 1998    Area of Use: Antarctica - Australian sector.    Datum Origin: No Data Available    Coord System: ellipsoidal    Ellipsoid Name: GRS 1980    Data Source: EPSG
186	4203	AGD84	t	Datum Name: Australian Geodetic Datum 1984    Area of Use: Australia - Queensland (Qld), South Australia (SA), Western Australia (WA).    Datum Origin: Fundamental point: Johnson Memorial Cairn. Latitude: 25 deg 56 min 54.5515 sec S; Longitude: 133 deg 12 min 30.0771 sec E (of Greenwich).    Coord System: ellipsoidal    Ellipsoid Name: Australian National Spheroid    Data Source: EPSG
187	4283	GDA94	t	Datum Name: Geocentric Datum of Australia 1994    Area of Use: Australia - Australian Capital Territory (ACT); New South Wales (NSW); Northern Territory (NT); Queensland (Qld); South Australia (SA); Tasmania (Tas); Western Australia (WA); Victoria (Vic).    Datum Origin: ITRF92 at epoch 1994.0    Coord System: ellipsoidal    Ellipsoid Name: GRS 1980    Data Source: EPSG
188	5711	Australian Height Datum	f	Datum Name: Australian Height Datum    Area of Use: Australia - Australian Capital Territory (ACT); New South Wales (NSW); Northern Territory (NT); Queensland; South Australia (SA); Western Australia (WA); Victoria.    Datum Origin: MSL 1966-68 at 30 gauges around coast.    Coord System: vertical    Ellipsoid Name: No Data Available    Data Source: EPSG
189	5712	Australian Height Datum (Tasmania)	f	Datum Name: Australian Height Datum (Tasmania)    Area of Use: Australia - Tasmania (Tas).    Datum Origin: MSL 1972 at Hobart and Burnie.    Coord System: vertical    Ellipsoid Name: No Data Available    Data Source: EPSG
190	5714	Mean Sea Level Height	f	Datum Name: Mean Sea Level    Area of Use: World.    Datum Origin: No Data Available    Coord System: vertical    Ellipsoid Name: No Data Available    Data Source: EPSG
191	5715	Mean Sea Level Depth	f	Datum Name: Mean Sea Level    Area of Use: World.    Datum Origin: No Data Available    Coord System: vertical    Ellipsoid Name: No Data Available    Data Source: EPSG
192	20348	AGD84 / AMG zone 48	f	Datum Name: Australian Geodetic Datum 1984    Area of Use: Australia - between 102 and 108 deg East.    Datum Origin: Fundamental point: Johnson Memorial Cairn. Latitude: 25 deg 56 min 54.5515 sec S; Longitude: 133 deg 12 min 30.0771 sec E (of Greenwich).    Coord System: Cartesian    Ellipsoid Name: Australian National Spheroid    Data Source: EPSG
193	20349	AGD84 / AMG zone 49	f	Datum Name: Australian Geodetic Datum 1984    Area of Use: Australia - between 108 and 114 deg East.    Datum Origin: Fundamental point: Johnson Memorial Cairn. Latitude: 25 deg 56 min 54.5515 sec S; Longitude: 133 deg 12 min 30.0771 sec E (of Greenwich).    Coord System: Cartesian    Ellipsoid Name: Australian National Spheroid    Data Source: EPSG
194	20350	AGD84 / AMG zone 50	f	Datum Name: Australian Geodetic Datum 1984    Area of Use: Australia - between 114 and 120 deg East.    Datum Origin: Fundamental point: Johnson Memorial Cairn. Latitude: 25 deg 56 min 54.5515 sec S; Longitude: 133 deg 12 min 30.0771 sec E (of Greenwich).    Coord System: Cartesian    Ellipsoid Name: Australian National Spheroid    Data Source: EPSG
195	20351	AGD84 / AMG zone 51	f	Datum Name: Australian Geodetic Datum 1984    Area of Use: Australia - between 120 and 126 deg East.    Datum Origin: Fundamental point: Johnson Memorial Cairn. Latitude: 25 deg 56 min 54.5515 sec S; Longitude: 133 deg 12 min 30.0771 sec E (of Greenwich).    Coord System: Cartesian    Ellipsoid Name: Australian National Spheroid    Data Source: EPSG
196	20352	AGD84 / AMG zone 52	f	Datum Name: Australian Geodetic Datum 1984    Area of Use: Australia - between 126 and 132 deg East.    Datum Origin: Fundamental point: Johnson Memorial Cairn. Latitude: 25 deg 56 min 54.5515 sec S; Longitude: 133 deg 12 min 30.0771 sec E (of Greenwich).    Coord System: Cartesian    Ellipsoid Name: Australian National Spheroid    Data Source: EPSG
197	20353	AGD84 / AMG zone 53	f	Datum Name: Australian Geodetic Datum 1984    Area of Use: Australia - between 132 and 138 deg East.    Datum Origin: Fundamental point: Johnson Memorial Cairn. Latitude: 25 deg 56 min 54.5515 sec S; Longitude: 133 deg 12 min 30.0771 sec E (of Greenwich).    Coord System: Cartesian    Ellipsoid Name: Australian National Spheroid    Data Source: EPSG
198	20354	AGD84 / AMG zone 54	f	Datum Name: Australian Geodetic Datum 1984    Area of Use: Australia - between 138 and 144 deg East.    Datum Origin: Fundamental point: Johnson Memorial Cairn. Latitude: 25 deg 56 min 54.5515 sec S; Longitude: 133 deg 12 min 30.0771 sec E (of Greenwich).    Coord System: Cartesian    Ellipsoid Name: Australian National Spheroid    Data Source: EPSG
199	20355	AGD84 / AMG zone 55	f	Datum Name: Australian Geodetic Datum 1984    Area of Use: Australia - between 144 and 150 deg East.    Datum Origin: Fundamental point: Johnson Memorial Cairn. Latitude: 25 deg 56 min 54.5515 sec S; Longitude: 133 deg 12 min 30.0771 sec E (of Greenwich).    Coord System: Cartesian    Ellipsoid Name: Australian National Spheroid    Data Source: EPSG
200	20356	AGD84 / AMG zone 56	f	Datum Name: Australian Geodetic Datum 1984    Area of Use: Australia - between 150 and 156 deg East.    Datum Origin: Fundamental point: Johnson Memorial Cairn. Latitude: 25 deg 56 min 54.5515 sec S; Longitude: 133 deg 12 min 30.0771 sec E (of Greenwich).    Coord System: Cartesian    Ellipsoid Name: Australian National Spheroid    Data Source: EPSG
201	20357	AGD84 / AMG zone 57	f	Datum Name: Australian Geodetic Datum 1984    Area of Use: Australia - between 156 and 162 deg East.    Datum Origin: Fundamental point: Johnson Memorial Cairn. Latitude: 25 deg 56 min 54.5515 sec S; Longitude: 133 deg 12 min 30.0771 sec E (of Greenwich).    Coord System: Cartesian    Ellipsoid Name: Australian National Spheroid    Data Source: EPSG
202	20358	AGD84 / AMG zone 58	f	Datum Name: Australian Geodetic Datum 1984    Area of Use: Australia - between 162 and 168 deg East.    Datum Origin: Fundamental point: Johnson Memorial Cairn. Latitude: 25 deg 56 min 54.5515 sec S; Longitude: 133 deg 12 min 30.0771 sec E (of Greenwich).    Coord System: Cartesian    Ellipsoid Name: Australian National Spheroid    Data Source: EPSG
203	28348	GDA94 / MGA zone 48	f	Datum Name: Geocentric Datum of Australia 1994    Area of Use: Australia - between 102 and 108 deg East.    Datum Origin: ITRF92 at epoch 1994.0    Coord System: Cartesian    Ellipsoid Name: GRS 1980    Data Source: EPSG
204	28349	GDA94 / MGA zone 49	f	Datum Name: Geocentric Datum of Australia 1994    Area of Use: Australia - between 108 and 114 deg East.    Datum Origin: ITRF92 at epoch 1994.0    Coord System: Cartesian    Ellipsoid Name: GRS 1980    Data Source: EPSG
205	28350	GDA94 / MGA zone 50	f	Datum Name: Geocentric Datum of Australia 1994    Area of Use: Australia - between 114 and 120 deg East.    Datum Origin: ITRF92 at epoch 1994.0    Coord System: Cartesian    Ellipsoid Name: GRS 1980    Data Source: EPSG
206	28351	GDA94 / MGA zone 51	f	Datum Name: Geocentric Datum of Australia 1994    Area of Use: Australia - between 120 and 126 deg East.    Datum Origin: ITRF92 at epoch 1994.0    Coord System: Cartesian    Ellipsoid Name: GRS 1980    Data Source: EPSG
207	28352	GDA94 / MGA zone 52	f	Datum Name: Geocentric Datum of Australia 1994    Area of Use: Australia - between 126 and 132 deg East.    Datum Origin: ITRF92 at epoch 1994.0    Coord System: Cartesian    Ellipsoid Name: GRS 1980    Data Source: EPSG
208	28353	GDA94 / MGA zone 53	f	Datum Name: Geocentric Datum of Australia 1994    Area of Use: Australia - between 132 and 138 deg East.    Datum Origin: ITRF92 at epoch 1994.0    Coord System: Cartesian    Ellipsoid Name: GRS 1980    Data Source: EPSG
209	28354	GDA94 / MGA zone 54	f	Datum Name: Geocentric Datum of Australia 1994    Area of Use: Australia - between 138 and 144 deg East.    Datum Origin: ITRF92 at epoch 1994.0    Coord System: Cartesian    Ellipsoid Name: GRS 1980    Data Source: EPSG
210	28355	GDA94 / MGA zone 55	f	Datum Name: Geocentric Datum of Australia 1994    Area of Use: Australia - between 144 and 150 deg East.    Datum Origin: ITRF92 at epoch 1994.0    Coord System: Cartesian    Ellipsoid Name: GRS 1980    Data Source: EPSG
211	28356	GDA94 / MGA zone 56	f	Datum Name: Geocentric Datum of Australia 1994    Area of Use: Australia - between 150 and 156 deg East.    Datum Origin: ITRF92 at epoch 1994.0    Coord System: Cartesian    Ellipsoid Name: GRS 1980    Data Source: EPSG
212	28357	GDA94 / MGA zone 57	f	Datum Name: Geocentric Datum of Australia 1994    Area of Use: Australia - between 156 and 162 deg East.    Datum Origin: ITRF92 at epoch 1994.0    Coord System: Cartesian    Ellipsoid Name: GRS 1980    Data Source: EPSG
213	28358	GDA94 / MGA zone 58	f	Datum Name: Geocentric Datum of Australia 1994    Area of Use: Australia - between 162 and 168 deg East.    Datum Origin: ITRF92 at epoch 1994.0    Coord System: Cartesian    Ellipsoid Name: GRS 1980    Data Source: EPSG
214	32748	WGS 84 / UTM zone 48S	f	Datum Name: World Geodetic System 1984    Area of Use: Between 102 and 108 deg East; southern hemisphere. Indonesia.    Datum Origin: Defined through a consistent set of station coordinates. These have changed with time: by 0.7m on 29/6/1994 [WGS 84 (G730)], a further 0.2m on 29/1/1997 [WGS 84 (G873)] and a further 0.06m on 20/1/2002 [WGS 84 (G1150)].    Coord System: Cartesian    Ellipsoid Name: WGS 84    Data Source: EPSG
215	32749	WGS 84 / UTM zone 49S	f	Datum Name: World Geodetic System 1984    Area of Use: Between 108 and 114 deg East; southern hemisphere. Australia. Indonesia.    Datum Origin: Defined through a consistent set of station coordinates. These have changed with time: by 0.7m on 29/6/1994 [WGS 84 (G730)], a further 0.2m on 29/1/1997 [WGS 84 (G873)] and a further 0.06m on 20/1/2002 [WGS 84 (G1150)].    Coord System: Cartesian    Ellipsoid Name: WGS 84    Data Source: EPSG
216	32750	WGS 84 / UTM zone 50S	f	Datum Name: World Geodetic System 1984    Area of Use: Between 114 and 120 deg East; southern hemisphere. Australia. Indonesia.    Datum Origin: Defined through a consistent set of station coordinates. These have changed with time: by 0.7m on 29/6/1994 [WGS 84 (G730)], a further 0.2m on 29/1/1997 [WGS 84 (G873)] and a further 0.06m on 20/1/2002 [WGS 84 (G1150)].    Coord System: Cartesian    Ellipsoid Name: WGS 84    Data Source: EPSG
217	32751	WGS 84 / UTM zone 51S	f	Datum Name: World Geodetic System 1984    Area of Use: Between 120 and 126 deg East; southern hemisphere. Australia. East Timor. Indonesia.    Datum Origin: Defined through a consistent set of station coordinates. These have changed with time: by 0.7m on 29/6/1994 [WGS 84 (G730)], a further 0.2m on 29/1/1997 [WGS 84 (G873)] and a further 0.06m on 20/1/2002 [WGS 84 (G1150)].    Coord System: Cartesian    Ellipsoid Name: WGS 84    Data Source: EPSG
218	32752	WGS 84 / UTM zone 52S	f	Datum Name: World Geodetic System 1984    Area of Use: Between 126 and 132 deg East; southern hemisphere. Australia. East Timor. Indonesia.    Datum Origin: Defined through a consistent set of station coordinates. These have changed with time: by 0.7m on 29/6/1994 [WGS 84 (G730)], a further 0.2m on 29/1/1997 [WGS 84 (G873)] and a further 0.06m on 20/1/2002 [WGS 84 (G1150)].    Coord System: Cartesian    Ellipsoid Name: WGS 84    Data Source: EPSG
219	32753	WGS 84 / UTM zone 53S	f	Datum Name: World Geodetic System 1984    Area of Use: Between 132 and 138 deg East; southern hemisphere. Australia.  Indonesia.    Datum Origin: Defined through a consistent set of station coordinates. These have changed with time: by 0.7m on 29/6/1994 [WGS 84 (G730)], a further 0.2m on 29/1/1997 [WGS 84 (G873)] and a further 0.06m on 20/1/2002 [WGS 84 (G1150)].    Coord System: Cartesian    Ellipsoid Name: WGS 84    Data Source: EPSG
220	32754	WGS 84 / UTM zone 54S	f	Datum Name: World Geodetic System 1984    Area of Use: Between 138 and 144 deg East; southern hemisphere. Australia. Indonesia. Papua New Guinea.    Datum Origin: Defined through a consistent set of station coordinates. These have changed with time: by 0.7m on 29/6/1994 [WGS 84 (G730)], a further 0.2m on 29/1/1997 [WGS 84 (G873)] and a further 0.06m on 20/1/2002 [WGS 84 (G1150)].    Coord System: Cartesian    Ellipsoid Name: WGS 84    Data Source: EPSG
221	32755	WGS 84 / UTM zone 55S	f	Datum Name: World Geodetic System 1984    Area of Use: Between 144 and 150 deg East; southern hemisphere. Australia. Papua New Guinea.    Datum Origin: Defined through a consistent set of station coordinates. These have changed with time: by 0.7m on 29/6/1994 [WGS 84 (G730)], a further 0.2m on 29/1/1997 [WGS 84 (G873)] and a further 0.06m on 20/1/2002 [WGS 84 (G1150)].    Coord System: Cartesian    Ellipsoid Name: WGS 84    Data Source: EPSG
222	32756	WGS 84 / UTM zone 56S	f	Datum Name: World Geodetic System 1984    Area of Use: Between 150 and 156 deg East; southern hemisphere. Australia. Papua New Guinea.    Datum Origin: Defined through a consistent set of station coordinates. These have changed with time: by 0.7m on 29/6/1994 [WGS 84 (G730)], a further 0.2m on 29/1/1997 [WGS 84 (G873)] and a further 0.06m on 20/1/2002 [WGS 84 (G1150)].    Coord System: Cartesian    Ellipsoid Name: WGS 84    Data Source: EPSG
223	32757	WGS 84 / UTM zone 57S	f	Datum Name: World Geodetic System 1984    Area of Use: Between 156 and 162 deg East; southern hemisphere.    Datum Origin: Defined through a consistent set of station coordinates. These have changed with time: by 0.7m on 29/6/1994 [WGS 84 (G730)], a further 0.2m on 29/1/1997 [WGS 84 (G873)] and a further 0.06m on 20/1/2002 [WGS 84 (G1150)].    Coord System: Cartesian    Ellipsoid Name: WGS 84    Data Source: EPSG
224	32758	WGS 84 / UTM zone 58S	f	Datum Name: World Geodetic System 1984    Area of Use: Between 162 and 168 deg East; southern hemisphere.    Datum Origin: Defined through a consistent set of station coordinates. These have changed with time: by 0.7m on 29/6/1994 [WGS 84 (G730)], a further 0.2m on 29/1/1997 [WGS 84 (G873)] and a further 0.06m on 20/1/2002 [WGS 84 (G1150)].    Coord System: Cartesian    Ellipsoid Name: WGS 84    Data Source: EPSG
225	3308	GDA94 / NSW Lambert	f	Datum Name: Geocentric Datum of Australia 1994 Area of Use: Australia - New South Wales (NSW). Datum Origin: ITRF92 at epoch 1994.0  Ellipsoid Name: GRS 1980 Data Source: EPSG
226	2914	NAD_1983_HARN_StatePlane_Oregon_South_FIPS_3602_Feet_Intl	f	I wonder if we can't just load the entire list at:\\nhttp://www.arcwebservices.com/v2006/help/index_Left.htm#StartTopic=support/pcs_name.htm#|SkinName=ArcWeb \\ninto the CV??
227	2276	NAD83 / Texas North Central (ftUS)	f	ESRI Name: NAD_1983_StatePlane_Texas_North_Central_FIPS_4202_Feet\\nArea of Use: United States (USA) - Texas - counties of: Andrews; Archer; Bailey; Baylor; Borden; Bowie; Callahan; Camp; Cass; Clay; Cochran; Collin; Cooke; Cottle; Crosby; Dallas; Dawson; Delta; Denton; Dickens; Eastland; Ellis; Erath; Fannin; Fisher; Floyd; Foard; Franklin; Gaines; Garza; Grayson; Gregg; Hale; Hardeman; Harrison; Haskell; Henderson; Hill; Hockley; Hood; Hopkins; Howard; Hunt; Jack; Johnson; Jones; Kaufman; Kent; King; Knox; Lamar; Lamb; Lubbock; Lynn; Marion; Martin; Mitchell; Montague; Morris; Motley; Navarro; Nolan; Palo Pinto; Panola; Parker; Rains; Red River; Rockwall; Rusk; Scurry; Shackelford; Smith; Somervell; Stephens; Stonewall; Tarrant; Taylor; Terry; Throckmorton; Titus; Upshur; Van Zandt; Wichita; Wilbarger; Wise; Wood; Yoakum; Young.
228	0	HRAP Grid Coordinate System	f	Datum Name: Hydrologic Rainfall Analysis Project (HRAP) grid coordinate system  Information: a polar stereographic projection true at 60°N / 105°W  Link:  http://www.nws.noaa.gov/oh/hrl/distmodel/hrap.htm#background
\.


--
-- Name: SpatialReferences_SpatialReferenceID_seq; Type: SEQUENCE SET; Schema: public; Owner: wmlclient
--

SELECT pg_catalog.setval('public."SpatialReferences_SpatialReferenceID_seq"', 1, false);


--
-- Data for Name: SpeciationCV; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."SpeciationCV" ("Term", "Definition") FROM stdin;
Al	Expressed as aluminium
As	Expressed as arsenic
B	Expressed as boron
Ba	Expressed as barium
Br	Expressed as bromine
C	Expressed as carbon
C2H6	Expressed as ethane
Ca	Expressed as calcium
CaCO3	Expressed as calcium carbonate
Cd	Expressed as cadmium
CH4	Expressed as methane
Cl	Expressed as chlorine
Co	Expressed as cobalt
CO2	Expressed as carbon dioxide
CO3	Expressed as carbonate
Cr	Expressed as chromium
Cu	Expressed as copper
delta 2H	Expressed as deuterium
delta N15	Expressed as nitrogen-15
delta O18 	Expressed as oxygen-18
EC	Expressed as electrical conductivity
F	Expressed as fluorine 
Fe	Expressed as iron
H2O	Expressed as water
HCO3	Expressed as hydrogen carbonate
Hg	Expressed as mercury
K	Expressed as potassium
Mg	Expressed as magnesium
Mn	Expressed as manganese
Mo	Expressed as molybdenum
N	Expressed as nitrogen
Na	Expressed as sodium
NH4	Expressed as ammonium
Ni	Expressed as nickel
NO2	Expressed as nitrite
NO3	Expressed as nitrate
Not Applicable	Speciation is not applicable
P	Expressed as phosphorus
Pb	Expressed as lead
pH	Expressed as pH
PO4	Expressed as phosphate
S	Expressed as Sulfur
Sb	Expressed as antimony
Se	Expressed as selenium
Si	Expressed as silicon
SiO2	Expressed as silicate
SN	Expressed as tin
SO4	Expressed as Sulfate
Sr	Expressed as strontium
TA	Expressed as total alkalinity
Ti	Expressed as titanium
Tl	Expressed as thallium
U	Expressed as uranium
Unknown	Speciation is unknown
V	Expressed as vanadium
Zn	Expressed as zinc
Zr	Expressed as zircon
\.


--
-- Data for Name: TopicCategoryCV; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."TopicCategoryCV" ("Term", "Definition") FROM stdin;
biota	Data associated with biological organisms
boundaries	Data associated with boundaries
climatology/meteorology/atmosphere	Data associated with climatology, meteorology, or the atmosphere
economy	Data associated with the economy
elevation	Data associated with elevation
environment	Data associated with the environment
farming	Data associated with agricultural production
geoscientificInformation	Data associated with geoscientific information
health	Data associated with health
imageryBaseMapsEarthCover	Data associated with imagery, base maps, or earth cover
inlandWaters	Data associated with inland waters
intelligenceMilitary	Data associated with intelligence or the military
location	Data associated with location
oceans	Data associated with oceans
planningCadastre	Data associated with planning or cadestre
society	Data associated with society
structure	Data associated with structure
transportation	Data associated with transportation
Unknown	The topic category is unknown
utilitiesCommunication	Data associated with utilities or communication
\.


--
-- Data for Name: Units; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."Units" ("UnitsID", "UnitsName", "UnitsType", "UnitsAbbreviation") FROM stdin;
1	percent	Dimensionless	%
2	degree	Angle	deg
3	grad	Angle	grad
4	radian	Angle	rad
5	degree north	Angle	degN
6	degree south	Angle	degS
7	degree west	Angle	degW
8	degree east	Angle	degE
9	arcminute	Angle	arcmin
10	arcsecond	Angle	arcsec
11	steradian	Angle	sr
12	acre	Area	ac
13	hectare	Area	ha
14	square centimeter	Area	cm^2
15	square foot	Area	ft^2
16	square kilometer	Area	km^2
17	square meter	Area	m^2
18	square mile	Area	mi^2
19	hertz	Frequency	Hz
20	darcy	Permeability	D
21	british thermal unit	Energy	BTU
22	calorie	Energy	cal
23	erg	Energy	erg
24	foot pound force	Energy	lbf ft
25	joule	Energy	J
26	kilowatt hour	Energy	kW hr
27	electronvolt	Energy	eV
28	langleys per day	Energy Flux	Ly/d
29	langleys per minute	Energy Flux	Ly/min
30	langleys per second	Energy Flux	Ly/s
31	megajoules per square meter per day	Energy Flux	MJ/m^2 d
32	watts per square centimeter	Energy Flux	W/cm^2
33	watts per square meter	Energy Flux	W/m^2
34	acre feet per year	Flow	ac ft/yr
35	cubic feet per second	Flow	cfs
36	cubic meters per second	Flow	m^3/s
37	cubic meters per day	Flow	m^3/d
38	gallons per minute	Flow	gpm
39	liters per second	Flow	L/s
40	million gallons per day	Flow	MGD
41	dyne	Force	dyn
42	kilogram force	Force	kgf
43	newton	Force	N
44	pound force	Force	lbf
45	kilo pound force	Force	kip
46	ounce force	Force	ozf
47	centimeter   	Length	cm
48	international foot	Length	ft
49	international inch	Length	in
50	international yard	Length	yd
51	kilometer	Length	km
52	meter	Length	m
53	international mile	Length	mi
54	millimeter	Length	mm
55	micron	Length	um
56	angstrom	Length	Å
57	femtometer	Length	fm
58	nautical mile	Length	nmi
59	lumen	Light	lm
60	lux	Light	lx
61	lambert	Light	La
62	stilb	Light	sb
63	phot	Light	ph
64	langley	Light	Ly
65	gram	Mass	g
66	kilogram	Mass	kg
67	milligram	Mass	mg
68	microgram	Mass	ug
69	pound mass (avoirdupois)	Mass	lb
70	slug	Mass	slug
71	metric ton	Mass	tonne
72	grain	Mass	grain
73	carat	Mass	car
74	atomic mass unit	Mass	amu
75	short ton	Mass	ton
76	BTU per hour	Power	BTU/hr
77	foot pound force per second	Power	lbf/s
78	horse power (shaft)	Power	hp
79	kilowatt	Power	kW
80	watt	Power	W
81	voltampere	Power	VA
82	atmospheres	Pressure/Stress	atm
83	pascal	Pressure/Stress	Pa
84	inch of mercury	Pressure/Stress	inch Hg
85	inch of water	Pressure/Stress	inch H2O
86	millimeter of mercury	Pressure/Stress	mm Hg
87	millimeter of water	Pressure/Stress	mm H2O
88	centimeter of mercury	Pressure/Stress	cm Hg
89	centimeter of water	Pressure/Stress	cm H2O
90	millibar	Pressure/Stress	mbar
91	pound force per square inch	Pressure/Stress	psi
92	torr	Pressure/Stress	torr
93	barie	Pressure/Stress	barie
94	meters per pixel	Resolution	meters per pixel
95	meters per meter	Scale	-
96	degree celsius	Temperature	degC
97	degree fahrenheit	Temperature	degF
98	degree rankine	Temperature	degR
99	degree kelvin	Temperature	degK
100	second	Time	s
101	millisecond	Time	millisec
102	minute	Time	min
103	hour	Time	hr
104	day	Time	d
105	week	Time	week
106	month	Time	month
107	common year (365 days)	Time	yr
108	leap year (366 days)	Time	leap yr
109	Julian year (365.25 days)	Time	jul yr
110	Gregorian year (365.2425 days)	Time	greg yr
111	centimeters per hour	Velocity	cm/hr
112	centimeters per second	Velocity	cm/s
113	feet per second	Velocity	ft/s
114	gallons per day per square foot	Velocity	gpd/ft^2
115	inches per hour	Velocity	in/hr
116	kilometers per hour	Velocity	km/h
117	meters per day	Velocity	m/d
118	meters per hour	Velocity	m/hr
119	meters per second	Velocity	m/s
120	miles per hour	Velocity	mph
121	millimeters per hour	Velocity	mm/hr
122	nautical mile per hour	Velocity	knot
123	acre foot	Volume	ac ft
124	cubic centimeter	Volume	cc
125	cubic foot	Volume	ft^3
126	cubic meter	Volume	m^3
127	hectare meter	Volume	hec m
128	liter	Volume	L
129	US gallon	Volume	gal
130	barrel	Volume	bbl
131	pint	Volume	pt
132	bushel	Volume	bu
133	teaspoon	Volume	tsp
134	tablespoon	Volume	tbsp
135	quart	Volume	qrt
136	ounce	Volume	oz
137	dimensionless	Dimensionless	-
138	mega joule	Energy	MJ
139	degrees minutes seconds	Angle	dddmmss
140	calories per square centimeter per day	Energy Flux	cal/cm^2 d
141	calories per square centimeter per minute	Energy Flux	cal/cm^2 min
142	milliliters per square centimeter per day	Hyporheic flux	ml/cm^2 d
144	megajoules per square meter	Energy per Area	MJ/m^2
145	gallons per day	Flow	gpd
146	million gallons per month	Flow	MGM
147	million gallons per year	Flow	MGY
148	short tons per day per foot	Mass flow per unit width	ton/d ft
149	lumens per square foot	Light Intensity	lm/ft^2
150	microeinsteins per square meter per second	Light Intensity	uE/m^2 s
151	alphas per meter	Light	a/m
152	microeinsteins per square meter	Light	uE/m^2
153	millimoles of photons per square meter	Light	mmol/m^2
154	absorbance per centimeter	Extinction/Absorbance	A/cm
155	nanogram	Mass	ng
156	picogram	Mass	pg
157	milliequivalents	Mass	meq
158	grams per square meter	Areal Density	g/m^2
159	milligrams per square meter	Areal Density	mg/m^2
160	micrograms per square meter	Areal Density	ug/m^2
161	grams per square meter per day	Areal Loading	g/m^2 d
162	grams per day	Loading	g/d
163	pounds per day	Loading	lb/d
164	pounds per mile	Loading	lb/mi
165	short tons per day	Loading	ton/d
166	milligrams per cubic meter per day	Productivity	mg/m^3 d
167	milligrams per square meter per day	Productivity	mg/m^2 d
168	volts	Potential Difference	V
169	millivolts	Potential Difference	mV
170	kilopascal	Pressure/Stress	kPa
171	megapascal	Pressure/Stress	MPa
172	becquerel	Radioactivity	Bq
173	becquerels per gram	Radioactivity	Bq/g
174	curie	Radioactivity	Ci
175	picocurie	Radioactivity	pCi
176	ohm	Resistance	ohm
177	ohm meter	Resistivity	ohm m
178	picocuries per gram	Specific Activity	pCi/g
179	picocuries per liter	Specific Activity	pCi/L
180	picocuries per milliliter	Specific Activity	pCi/ml
181	hour minute	Time	hhmm
182	year month day	Time	yymmdd
183	year day (Julian)	Time	yyddd
184	inches per day	Velocity	in/d
185	inches per week	Velocity	in/week
186	inches per storm	Precipitation	in/storm
187	thousand acre feet	Volume	10^3 ac ft
188	milliliter	Volume	ml
189	cubic feet per second days	Volume	cfs d
190	thousand gallons	Volume	10^3 gal
191	million gallons	Volume	10^6 gal
192	microsiemens per centimeter	Electrical Conductivity	uS/cm
193	practical salinity units 	Salinity	psu
194	decibel	Sound	dB
195	cubic centimeters per gram	Specific Volume	cm^3/g
196	square meters per gram	Specific Surface Area 	m^2/g
197	short tons per acre foot	Concentration	ton/ac ft
198	grams per cubic centimeter	Concentration	g/cm^3
199	milligrams per liter	Concentration	mg/L
200	nanograms per cubic meter	Concentration	ng/m^3
201	nanograms per liter	Concentration	ng/L
202	grams per liter	Concentration	g/L
203	micrograms per cubic meter	Concentration	ug/m^3
204	micrograms per liter	Concentration	ug/L
205	parts per million	Concentration	ppm
206	parts per billion	Concentration	ppb
207	parts per trillion	Concentration	ppt
208	parts per quintillion	Concentration	ppqt
209	parts per quadrillion	Concentration	ppq
210	per mille	Concentration	%o
211	microequivalents per liter	Concentration	ueq/L
212	milliequivalents per liter	Concentration	meq/L
213	milliequivalents per 100 gram	Concentration	meq/100 g
214	milliosmols per kilogram	Concentration	mOsm/kg
215	nanomoles per liter	Concentration	nmol/L
216	picograms per cubic meter	Concentration	pg/m^3
217	picograms per liter	Concentration	pg/L
218	picograms per milliliter	Concentration	pg/ml
219	tritium units	Concentration	TU
220	jackson turbidity units	Turbidity	JTU
221	nephelometric turbidity units	Turbidity	NTU
222	nephelometric turbidity multibeam unit	Turbidity	NTMU
223	nephelometric turbidity ratio unit	Turbidity	NTRU
224	formazin nephelometric multibeam unit	Turbidity	FNMU
225	formazin nephelometric ratio unit	Turbidity	FNRU
226	formazin nephelometric unit	Turbidity	FNU
227	formazin attenuation unit	Turbidity	FAU
228	formazin backscatter unit 	Turbidity	FBU
229	backscatter units	Turbidity	BU
230	attenuation units	Turbidity	AU
231	platinum cobalt units	Color	PCU
232	the ratio between UV absorbance at 254 nm and DOC level	Specific UV Absorbance	L/(mg DOC/cm)
233	billion colonies per day	Organism Loading	10^9 colonies/d
234	number of organisms per square meter	Organism Concentration	#/m^2
235	number of organisms per liter	Organism Concentration	#/L
236	number or organisms per cubic meter	Organism Concentration	#/m^3
237	cells per milliliter	Organism Concentration	cells/ml
238	cells per square millimeter	Organism Concentration	cells/mm^2
239	colonies per 100 milliliters	Organism Concentration	colonies/100 ml
240	colonies per milliliter	Organism Concentration	colonies/ml
241	colonies per gram	Organism Concentration	colonies/g
242	colony forming units per milliliter	Organism Concentration	CFU/ml
243	cysts per 10 liters	Organism Concentration	cysts/10 L
244	cysts per 100 liters	Organism Concentration	cysts/100 L
245	oocysts per 10 liters	Organism Concentration	oocysts/10 L
246	oocysts per 100 liters	Organism Concentration	oocysts/100 L
247	most probable number	Organism Concentration	MPN
248	most probable number per 100 liters	Organism Concentration	MPN/100 L
249	most probable number per 100 milliliters	Organism Concentration	MPN/100 ml
250	most probable number per gram	Organism Concentration	MPN/g
251	plaque-forming units per 100 liters	Organism Concentration	PFU/100 L
252	plaques per 100 milliliters	Organism Concentration	plaques/100 ml
253	counts per second	Rate	#/s
254	per day	Rate	1/d
255	nanograms per square meter per hour	Volatilization Rate	ng/m^2 hr
256	nanograms per square meter per week	Volatilization Rate	ng/m^2 week
257	count	Dimensionless	#
258	categorical	Dimensionless	code
259	absorbance per centimeter per mg/L of given acid 	Absorbance	100/cm mg/L
260	per liter	Concentration Ratio	1/L
261	per mille per hour	Sedimentation Rate	%o/hr
262	gallons per batch	Flow	gpb
263	cubic feet per barrel	Concentration	ft^3/bbl
264	per mille by volume	Concentration	%o by vol
265	per mille per hour by volume	Sedimentation Rate	%o/hr by vol
266	micromoles	Amount	umol
267	tons of calcium carbonate per kiloton	Net Neutralization Potential	tCaCO3/Kt
268	siemens per meter	Electrical Conductivity	S/m
269	millisiemens per centimeter	Electrical Conductivity	mS/cm
270	siemens per centimeter	Electrical Conductivity	S/cm
271	practical salinity scale	Salinity	pss
272	per meter	Light Extinction	1/m
273	normal	Normality	N
274	nanomoles per kilogram	Concentration	nmol/kg
275	millimoles per kilogram	Concentration	mmol/kg
276	millimoles per square meter per hour	Areal Flux	mmol/m^2 hr
277	milligrams per cubic meter per hour	Productivity	mg/m^3 hr
278	milligrams per day	Loading	mg/d
279	liters per minute	Flow	L/min
280	liters per day	Flow	L/d
281	jackson candle units 	Turbidity	JCU
282	grains per gallon	Concentration	gpg
283	gallons per second	Flow	gps
284	gallons per hour	Flow	gph
285	foot candle	Illuminance	ftc
286	fibers per liter	Concentration	fibers/L
287	drips per minute	Flow	drips/min
288	cubic centimeters per second	Flow	cm^3/sec
289	colony forming units	Organism Concentration	CFU
290	colony forming units per 100 milliliter	Organism Concentration	CFU/100 ml
291	cubic feet per minute	Flow	cfm
292	ADMI color unit	Color	ADMI
293	percent by volume	Concentration	% by vol
294	number of organisms per 500 milliliter	Organism Concentration	#/500 ml
295	number of organisms per 100 gallon	Organism Concentration	#/100 gal
296	grams per cubic meter per hour	Productivity	g/m^3 hr
297	grams per minute	Loading	g/min
298	grams per second	Loading	g/s
299	million cubic feet	Volume	10^6 ft^3
300	month year	Time	mmyy
301	bar	Pressure	bar
302	decisiemens per centimeter	Electrical Conductivity	dS/cm
303	micromoles per liter	Concentration	umol/L
304	Joules per square centimeter	Energy per Area	J/cm^2
305	millimeters per day	velocity	mm/day
306	parts per thousand	Concentration	ppth
307	megaliter	Volume	ML
308	Percent Saturation	Concentration	% Sat
309	pH Unit	Dimensionless	pH
310	millimeters per second	Velocity	mm/s
311	liters per hour	Flow	L/hr
312	cubic hecto meter	Volume	(hm)^3
313	mols per cubic meter	Concentration or organism concentration	mol/m^3
314	kilo grams per month	Loading	kg/month
315	Hecto Pascal	Pressure/Stress	hPa
316	kilo grams per cubic meter	Concentration	kg/m^3
317	short tons per month	Loading	ton/month
318	micromoles per square meter per second	Areal Flux	umol/m^2 s
319	grams per square meter per hour	Areal Flux	g/m^2 hr
320	milligrams per cubic meter	Concentration	mg/m^3
321	meters squared per second squared	Velocity	m^2/s^2
322	squared degree Celsius	Temperature	(DegC)^2
323	milligrams per cubic meter squared	Concentration	(mg/m^3)^2
324	meters per second degree Celsius	Temperature	m/s DegC
325	millimoles per square meter per second	Areal Flux	mmol/m^2 s
326	degree Celsius millimoles per cubic meter	Concentration	DegC mmol/m^3
327	millimoles per cubic meter	Concentration	mmol/m^3
328	millimoles per cubic meter squared	Concentration	(mmol/m^3)^2
329	Langleys per hour	Energy Flux	Ly/hr
330	hits per square centimeter	Precipitation	hits/cm^2
331	hits per square centimeter per hour	Velocity	hits/cm^2 hr
332	relative fluorescence units	Fluorescence	RFU
333	kilograms per hectare per day	Areal Flux	kg/ha d
334	kilowatts per square meter	Energy Flux	kW/m^2
335	kilograms per square meter	Areal Density	kg/m^2
336	microeinsteins per square meter per day	Light Intensity	uE/m^2 d
337	microgram per milliliter	Concentration	ug/mL
338	Newton per square meter	Pressure/Stress	Newton/m^2
339	micromoles per liter per hour	Pressure/Stress	umol/L hr
340	decisiemens per meter	Electrical Conductivity	dS/m
341	milligrams per kilogram	Mass Fraction	mg/Kg
342	number of organisms per 100 milliliter	Organism Concentration	#/100 mL
343	micrograms per kilogram	Mass Fraction	ug/Kg
344	grams per kilogram	Mass Fraction	g/Kg
345	acre feet per month	Flow	ac ft/mo
346	acre feet per half month	Flow	ac ft/0.5 mo
347	cubic meters per minute	Flow	m^3/min
348	count per half cubic foot	Concentration	#/((ft^3)/2)
0	Unknown	Unknown	?
\.


--
-- Name: Units_UnitsID_seq; Type: SEQUENCE SET; Schema: public; Owner: wmlclient
--

SELECT pg_catalog.setval('public."Units_UnitsID_seq"', 1, false);


--
-- Data for Name: ValueTypeCV; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."ValueTypeCV" ("Term", "Definition") FROM stdin;
Calibration Value	A value used as part of the calibration of an instrument at a particular time.
Derived Value	Value that is directly derived from an observation or set of observations
Field Observation	Observation of a variable using a field instrument
Model Simulation Result	Values generated by a simulation model
Sample	Observation that is the result of analyzing a sample in a laboratory
Unknown	The value type is unknown
\.


--
-- Data for Name: VariableNameCV; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."VariableNameCV" ("Term", "Definition") FROM stdin;
Wind gust speed	Speed of gusts of wind
Wind Run	The length of flow of air past a point over a time interval. Windspeed times the interval of time.
Wind speed	Wind speed
Wind stress	Drag or trangential force per unit area exerted on a surface by the adjacent layer of moving air
Wrack coverage	Areal coverage of dead vegetation
Zeaxanthin	The phytoplankton pigment Zeaxanthin
Zinc	Zinc (Zn)
Zinc, dissolved	Dissolved Zinc (Zn)
Zircon, dissolved	Dissolved Zircon (Zr)
Zooplankton	Zooplanktonic organisms, non-specific
19-Hexanoyloxyfucoxanthin	The phytoplankton pigment 19-Hexanoyloxyfucoxanthin
9 cis-Neoxanthin	The phytoplankton pigment  9 cis-Neoxanthin
Acid neutralizing capacity	Acid neutralizing capacity 
Agency code	Code for the agency which analyzed the sample
Albedo	The ratio of reflected to incident light.
Alkalinity, bicarbonate	Bicarbonate Alkalinity 
Alkalinity, carbonate 	Carbonate Alkalinity 
Alkalinity, carbonate plus bicarbonate	Alkalinity, carbonate plus bicarbonate
Alkalinity, hydroxide 	Hydroxide Alkalinity 
Alkalinity, total 	Total Alkalinity
Alloxanthin	The phytoplankton pigment Alloxanthin
Aluminium	Aluminium (Al)
Aluminum, dissolved	Dissolved Aluminum (Al)
Ammonium flux	Ammonium (NH4) flux
Antimony	Antimony (Sb)
Area	Area of a measurement location
Arsenic	Arsenic (As)
Asteridae coverage	Areal coverage of the plant Asteridae
Barium, dissolved	Dissolved Barium (Ba)
Barium, total	Total Barium (Ba)
Barometric pressure	Barometric pressure
Baseflow	The portion of streamflow (discharge) that is supplied by groundwater sources.
Batis maritima Coverage	Areal coverage of the plant Batis maritima
Battery Temperature	The battery temperature of a datalogger or sensing system
Battery voltage	The battery voltage of a datalogger or sensing system, often recorded as an indicator of data reliability
Benthos	Benthic species
Bicarbonate	Bicarbonate (HCO3-)
Biogenic silica	Hydrated silica (SiO2 nH20)
Biomass, phytoplankton	Total mass of phytoplankton, per unit area or volume
Biomass, total	Total biomass
Blue-green algae (cyanobacteria), phycocyanin	Blue-green algae (cyanobacteria) with phycocyanin pigments
BOD1	1-day Biochemical Oxygen Demand
BOD2, carbonaceous	2-day Carbonaceous Biochemical Oxygen Demand
BOD20	20-day Biochemical Oxygen Demand
BOD20, carbonaceous	20-day Carbonaceous Biochemical Oxygen Demand
BOD20, nitrogenous	20-day Nitrogenous Biochemical Oxygen Demand
BOD3, carbonaceous	3-day Carbonaceous Biochemical Oxygen Demand
BOD4, carbonaceous	4-day Carbonaceous Biological Oxygen Demand
BOD5	5-day Biochemical Oxygen Demand
BOD5, carbonaceous	5-day Carbonaceous Biochemical Oxygen Demand
BOD5, nitrogenous	5-day Nitrogenous Biochemical Oxygen Demand
BOD6, carbonaceous	6-day Carbonaceous Biological Oxygen Demand
BOD7, carbonaceous	7-day Carbonaceous Biochemical Oxygen Demand
BODu	Ultimate Biochemical Oxygen Demand
BODu, carbonaceous	Carbonaceous Ultimate Biochemical Oxygen Demand
BODu, nitrogenous	Nitrogenous Ultimate Biochemical Oxygen Demand
Borehole log material classification	Classification of material encountered by a driller at various depths during the drilling of a well and recorded in the borehole log.
Boron	Boron (B)
Borrichia frutescens Coverage	Areal coverage of the plant Borrichia frutescens
Bromide	Bromide
Bromine	Bromine (Br)
Bromine, dissolved	Dissolved Bromine (Br)
Bulk electrical conductivity	Bulk electrical conductivity of a medium measured using a sensor such as time domain reflectometry (TDR), as a raw sensor response in the measurement of a quantity like soil moisture.
Cadmium	Cadmium (Cd)
Calcium 	Calcium (Ca) 
Calcium, dissolved	Dissolved Calcium (Ca)
Canthaxanthin	The phytoplankton pigment Canthaxanthin
Carbon dioxide	Carbon dioxide
Carbon dioxide Flux	Carbon dioxide (CO2) flux
Carbon dioxide Storage Flux	Carbon dioxide (CO2) storage flux
Carbon dioxide, transducer signal	Carbon dioxide (CO2), raw data from sensor
Carbon disulfide	Carbon disulfide (CS2)
Carbon tetrachloride	Carbon tetrachloride (CCl4)
Carbon to Nitrogen molar ratio	C:N (molar)
Carbon, dissolved inorganic	Dissolved Inorganic Carbon
Carbon, dissolved organic	Dissolved Organic Carbon
Carbon, dissolved total	Dissolved Total (Organic+Inorganic) Carbon
Carbon, particulate organic	Particulate organic carbon in suspension
Carbon, suspended inorganic	Suspended Inorganic Carbon
Carbon, suspended organic	DEPRECATED -- The use of this term is discouraged in favor of the use of the synonymous term \\"Carbon, particulate organic\\".
Carbon, suspened total	Suspended Total (Organic+Inorganic) Carbon
Carbon, total	Total (Dissolved+Particulate) Carbon
Carbon, total inorganic	Total (Dissolved+Particulate) Inorganic Carbon
Carbon, total organic	Total (Dissolved+Particulate) Organic Carbon
Carbon, total solid phase	Total solid phase carbon
Carbonate	Carbonate ion (CO3-2) concentration
Chloride	Chloride (Cl-)
Chloride, total	Total Chloride (Cl-)
Chlorine	Chlorine (Cl)
Chlorine, dissolved	Dissolved Chlorine (Cl)
Chlorophyll (a+b+c)	Chlorophyll (a+b+c)
Chlorophyll a	Chlorophyll a
Chlorophyll a allomer	The phytoplankton pigment Chlorophyll a allomer
Chlorophyll a, corrected for pheophytin	Chlorphyll a corrected for pheophytin
Chlorophyll a, uncorrected for pheophytin	Chlorophyll a uncorrected for pheophytin
Chlorophyll b	Chlorophyll b
Chlorophyll c	Chlorophyll c
Chlorophyll c1 and c2	Chlorophyll c1 and c2
Chlorophyll Fluorescence	Chlorophyll Fluorescence
Chromium (III)	Trivalent Chromium
Chromium (VI)	Hexavalent Chromium
Chromium, dissolved	Dissolved Chromium
Chromium, total	Chromium, all forms
Cobalt	Cobalt (Co)
Cobalt, dissolved	Dissolved Cobalt (Co)
COD	Chemical oxygen demand
Coliform, fecal	Fecal Coliform
Coliform, total	Total Coliform
Color	Color in quantified in color units
Colored Dissolved Organic Matter	The concentration of colored dissolved organic matter (humic substances)
Container number	The identifying number for a water sampler container.
Copper	Copper (Cu)
Copper, dissolved	Dissolved Copper (Cu)
Cryptophytes	The chlorophyll a concentration contributed by cryptophytes
Cuscuta spp. coverage	Areal coverage of the plant Cuscuta spp.
Density	Density
Deuterium	Deuterium (2H), Delta D
Diadinoxanthin	The phytoplankton pigment Diadinoxanthin
Diatoxanthin	The phytoplankton pigment Diatoxanthin
Dinoflagellates	The chlorophyll a concentration contributed by Dinoflagellates
Discharge	Discharge
Distance	Distance measured from a sensor to a target object such as the surface of a water body or snow surface.
Distichlis spicata Coverage	Areal coverage of the plant Distichlis spicata
E-coli	Escherichia coli
Electric Energy	Electric Energy
Electric Power	Electric Power
Electrical conductivity	Electrical conductivity
Enterococci	Enterococcal bacteria
Ethane, dissolved	Dissolved Ethane (C2H6)
Evaporation	Evaporation
Evapotranspiration	Evapotranspiration
Evapotranspiration, potential	The amount of water that could be evaporated and transpired if there was sufficient water available.
Fish detections	The number of fish identified by the detection equipment
Flash memory error count	A counter which counts the number of  datalogger flash memory errors
Fluoride	Fluoride - F-
Fluorine	Fluorine (F-)
Fluorine, dissolved	Dissolved Fluorine (Fl)
Friction velocity	Friction velocity
Gage height	Water level with regard to an arbitrary gage datum (also see Water depth for comparison)
Global Radiation	Solar radiation, direct and diffuse, received from a solid angle of 2p steradians on a horizontal surface. \\nSource: World Meteorological Organization, Meteoterm
Ground heat flux	Ground heat flux
Groundwater Depth	Groundwater depth is the distance between the water surface and the ground surface at a specific location specified by the site location and offset.
Hardness, carbonate	Carbonate hardness also known as temporary hardness
Hardness, non-carbonate	Non-carbonate hardness
Hardness, total	Total hardness
Heat index	The combination effect of heat and humidity on the temperature felt by people.
Hydrogen sulfide	Hydrogen sulfide (H2S)
Hydrogen-2, stable isotope ratio delta	Difference in the  2H:1H ratio between the sample and standard
Imaginary dielectric constant	Soil reponse of a reflected standing electromagnetic wave of a particular frequency which is related to the dissipation (or loss) of energy within the medium. This is the imaginary portion of the complex dielectric constant.
Iron sulfide	Iron sulfide (FeS2)
Iron, dissolved	Dissolved Iron (Fe)
Iron, ferric	Ferric Iron (Fe+3)
Iron, ferrous	Ferrous Iron (Fe+2)
Iva frutescens coverage	Areal coverage of the plant Iva frutescens
Latent Heat Flux	Latent Heat Flux
Latitude	Latitude as a variable measurement or observation (Spatial reference to be designated in methods).  This is distinct from the latitude of a site which is a site attribute.
Lead	Lead (Pb)
Leaf wetness	The effect of moisture settling on the surface of a leaf as a result of either condensation or rainfall.
Light attenuation coefficient	Light attenuation coefficient
Limonium nashii Coverage	Areal coverage of the plant Limonium nashii
Lithium	Lithium (Li)
Longitude	Longitude as a variable measurement or observation (Spatial reference to be designated in methods). This is distinct from the longitude of a site which is a site attribute.
Low battery count	A counter of the number of times the battery voltage dropped below a minimum threshold
LSI	Langelier Saturation Index is an indicator of the degree of saturation of water with respect to calcium carbonate 
Lycium carolinianum Coverage	Areal coverage of the plant Lycium carolinianum
Magnesium	Magnesium (Mg)
Magnesium, dissolved	Dissolved Magnesium (Mg)
Manganese	Manganese (Mn)
Manganese, dissolved	Dissolved Manganese (Mn)
Mercury	Mercury (Hg)
Methane, dissolved	Dissolved Methane (CH4)
Methylmercury	Methylmercury (CH3Hg)
Molybdenum	Molybdenum (Mo)
Momentum flux	Momentum flux
Monanthochloe littoralis Coverage	Areal coverage of the plant Monanthochloe littoralis
N, albuminoid	Albuminoid Nitrogen
Net heat flux	Outgoing rate of heat energy transfer minus the incoming rate of heat energy transfer through a given area
Nickel	Nickel (Ni)
Nickel, dissolved	Dissolved Nickel (Ni)
Nitrogen, Dissolved Inorganic	Dissolved inorganic nitrogen
Nitrogen, dissolved Kjeldahl	Dissolved Kjeldahl (organic nitrogen + ammonia (NH3) + ammonium (NH4))nitrogen
Nitrogen, dissolved nitrate (NO3)	Dissolved nitrate (NO3) nitrogen
Nitrogen, dissolved nitrite (NO2)	Dissolved nitrite (NO2) nitrogen
Nitrogen, dissolved nitrite (NO2) + nitrate (NO3)	Dissolved nitrite (NO2) + nitrate (NO3) nitrogen
Nitrogen, Dissolved Organic	Dissolved Organic Nitrogen
Nitrogen, gas	Gaseous Nitrogen (N2)
Nitrogen, inorganic	Total Inorganic Nitrogen
Nitrogen, NH3	Free Ammonia (NH3)
Nitrogen, NH3 + NH4	Total (free+ionized) Ammonia
Nitrogen, NH4	Ammonium (NH4)
Nitrogen, nitrate (NO3)	Nitrate (NO3) Nitrogen
Nitrogen, nitrite (NO2)	Nitrite (NO2) Nitrogen
Nitrogen, nitrite (NO2) + nitrate (NO3)	Nitrite (NO2) + Nitrate (NO3) Nitrogen
Nitrogen, organic	Organic Nitrogen
Nitrogen, organic kjeldahl	Organic Kjeldahl (organic nitrogen + ammonia (NH3) + ammonium (NH4)) nitrogen
Nitrogen, particulate organic	Particulate Organic Nitrogen
Nitrogen, total	Total Nitrogen (NO3+NO2+NH4+NH3+Organic)
Nitrogen, total dissolved	Total dissolved nitrogen
Nitrogen, total kjeldahl	Total Kjeldahl Nitrogen (Ammonia+Organic) 
Nitrogen, total organic	Total (dissolved + particulate) organic nitrogen
Nitrogen-15	15 Nitrogen, Delta Nitrogen
Nitrogen-15, stable isotope ratio delta	Difference in the 15N:14N ratio between the sample and standard
No vegetation coverage	Areal coverage of no vegetation
Odor	Odor
Oxygen flux	Oxygen (O2) flux
Oxygen, dissolved	Dissolved oxygen
Oxygen, dissolved percent of saturation	Dissolved oxygen, percent saturation
Oxygen, dissolved, transducer signal	Dissolved oxygen, raw data from sensor
Oxygen-18	18 O, Delta O
Oxygen-18, stable isotope ratio delta	Difference in the 18O:16O ratio between the sample and standard
Ozone	Ozone (O3)
Parameter	Parameter related to a hydrologic process.  An example usage would be for a starge-discharge relation parameter.
Peridinin	The phytoplankton pigment Peridinin
Permittivity	Permittivity is a physical quantity that describes how an electric field affects, and is affected by a dielectric medium, and is determined by the ability of a material to polarize in response to the field, and thereby reduce the total electric field inside the material. Thus, permittivity relates to a material\n's ability to transmit (or \\"permit\\") an electric field.
Petroleum hydrocarbon, total	Total petroleum hydrocarbon
pH	pH is the measure of the acidity or alkalinity of a solution. pH is formally a measure of the activity of dissolved hydrogen ions (H+).  Solutions in which the concentration of H+ exceeds that of OH- have a pH value lower than 7.0 and are known as acids. 
Pheophytin	Pheophytin (Chlorophyll which has lost the central Mg ion) is a degradation product of Chlorophyll
Phosphorus, dissolved	Dissolved Phosphorus (P)
Phosphorus, dissolved organic	Dissolved organic phosphorus
Phosphorus, inorganic 	Inorganic Phosphorus
Phosphorus, organic	Organic Phosphorus
Phosphorus, orthophosphate	Orthophosphate Phosphorus
Phosphorus, orthophosphate dissolved	Dissolved orthophosphate phosphorus
Phosphorus, particulate	Particulate phosphorus
Phosphorus, particulate organic	Particulate organic phosphorus in suspension
Phosphorus, phosphate (PO4)	Phosphate Phosphorus
Phosphorus, phosphate flux	Phosphate (PO4) flux
Phosphorus, polyphosphate	Polyphosphate Phosphorus
Phosphorus, total	Total Phosphorus
Phosphorus, total dissolved	Total dissolved phosphorus
Phytoplankton	Measurement of phytoplankton with no differentiation between species
Position	Position of an element that interacts with water such as reservoir gates
Potassium	Potassium (K)
Potassium, dissolved	Dissolved Potassium (K)
Precipitation	Precipitation such as rainfall. Should not be confused with settling.
Pressure, absolute	Pressure
Pressure, gauge	Pressure relative to the local atmospheric or ambient pressure
Primary Productivity	Primary Productivity
Program signature	A unique data recorder program identifier which is useful for knowing when the source code in the data recorder has been modified.
Radiation, incoming longwave	Incoming Longwave Radiation
Radiation, incoming PAR	Incoming Photosynthetically-Active Radiation
Radiation, incoming shortwave	Incoming Shortwave Radiation
Radiation, incoming UV-A	Incoming Ultraviolet A Radiation
Radiation, incoming UV-B	Incoming Ultraviolet B Radiation
Radiation, net	Net Radiation
Radiation, net longwave	Net Longwave Radiation
Radiation, net PAR	Net Photosynthetically-Active Radiation
Radiation, net shortwave	Net Shortwave radiation
Radiation, outgoing longwave	Outgoing Longwave Radiation
Radiation, outgoing PAR	Outgoing Photosynthetically-Active Radiation
Radiation, outgoing shortwave	Outgoing Shortwave Radiation
Radiation, total incoming	Total amount of incoming radiation from all frequencies
Radiation, total outgoing	Total amount of outgoing radiation from all frequencies
Radiation, total shortwave	Total Shortwave Radiation
Rainfall rate	A measure of the intensity of rainfall, calculated as the depth of water to fall over a given time period if the intensity were to remain constant over that time interval (in/hr, mm/hr, etc)
Real dielectric constant	Soil reponse of a reflected standing electromagnetic wave of a particular frequency which is related to the stored energy within the medium.  This is the real portion of the complex dielectric constant.
Recorder code	A code used to identifier a data recorder.
Reduction potential	Oxidation-reduction potential
Relative humidity	Relative humidity
Reservoir storage	Reservoir water volume
Respiration, net	Net respiration
Salicornia bigelovii coverage	Areal coverage of the plant Salicornia bigelovii
Salicornia virginica coverage	Areal coverage of the plant Salicornia virginica
Salinity	Salinity
Secchi depth	Secchi depth
Selenium	Selenium (Se)
Sensible Heat Flux	Sensible Heat Flux
Sequence number	A counter of events in a sequence
Signal-to-noise ratio	Signal-to-noise ratio (often abbreviated SNR or S/N) is defined as the ratio of a signal power to the noise power corrupting the signal. The higher the ratio, the less obtrusive the background noise is.
Silica	Silica (SiO2)
Silicate	Silicate.  Chemical compound containing silicon, oxygen, and one or more metals, e.g., aluminum, barium, beryllium, calcium, iron, magnesium, manganese, potassium, sodium, or zirconium.
Silicic acid	Hydrated silica disolved in water
Silicic acid flux	Silicate acid (H4SiO4) flux
Silicon	Silicon (Si)  
Silicon, dissolved	Dissolved Silicon (Si)
Snow depth	Snow depth
Snow Water Equivalent	The depth of water if a snow cover is completely melted, expressed in units of depth, on a corresponding horizontal surface area.
Sodium	Sodium (Na)
Sodium adsorption ratio	Sodium adsorption ratio
Sodium plus potassium	Sodium plus potassium
Sodium, dissolved	Dissolved Sodium (Na)
Sodium, fraction of cations	Sodium, fraction of cations
Solids, fixed Dissolved	Fixed Dissolved Solids
Solids, fixed Suspended	Fixed Suspended Solids
Solids, total	Total Solids
Solids, total Dissolved	Total Dissolved Solids
Solids, total Fixed	Total Fixed Solids
Solids, total Suspended	Total Suspended Solids
Solids, total Volatile	Total Volatile Solids
Solids, volatile Dissolved	Volatile Dissolved Solids
Solids, volatile Suspended	Volatile Suspended Solids
Spartina alterniflora coverage	Areal coverage of the plant Spartina alterniflora
Spartina spartinea coverage	Areal coverage of the plant Spartina spartinea
Specific conductance	Specific conductance
Streamflow	The volume of water flowing past a fixed point.  Equivalent to discharge
Streptococci, fecal	Fecal Streptococci
Strontium	Strontium (Sr)
Strontium, dissolved	Dissolved Strontium (Sr)
Strontium, total	Total Strontium (Sr)
Suaeda linearis coverage	Areal coverage of the plant Suaeda linearis
Suaeda maritima coverage	Areal coverage of the plant Suaeda maritima
Sulfate	Sulfate (SO4)
Sulfate, dissolved	Dissolved Sulfate (SO4)
Sulfur	Sulfur (S)
Sulfur dioxide	Sulfur dioxide (SO2)
Sulfur, organic	Organic Sulfur
Sulfur, pyritic	Pyritic Sulfur
Sunshine duration	Sunshine duration
Table overrun error count	A counter which counts the number of datalogger table overrun errors
TDR waveform relative length	Time domain reflextometry, apparent length divided by probe length. Square root of dielectric
Temperature	Temperature
Temperature, dew point	Dew point temperature
Temperature, transducer signal	Temperature, raw data from sensor
Thallium	Thallium (Tl)
THSW Index	The THSW Index uses temperature, humidity, solar radiation, and wind speed to calculate an apparent temperature.
THW Index	The THW Index uses temperature, humidity, and wind speed to calculate an apparent temperature.
Tide stage	Tidal stage
Tin	Tin (Sn)
Titanium	Titanium (Ti)
Transient species coverage	Areal coverage of transient species
Transpiration	Transpiration
TSI	Carlson Trophic State Index is a measurement of eutrophication based on Secchi depth
Turbidity	Turbidity
Uranium	Uranium (U)
Urea	Urea ((NH2)2CO)
Urea flux	Urea ((NH2)2CO) flux
Vanadium	Vanadium (V)
Vapor pressure	The pressure of a vapor in equilibrium with its non-vapor phases
Vapor pressure deficit	The difference between the actual water vapor pressure and the saturation of water vapor pressure at a particular temperature.
Velocity	The velocity of a substance, fluid or object
Visibility	Visibility
Voltage	Voltage or Electrical Potential
Volume	Volume. To quantify discharge or hydrograph volume or some other volume measurement.
Volumetric water content	Volume of liquid water relative to bulk volume. Used for example to quantify soil moisture
Watchdog error count	A counter which counts the number of total datalogger watchdog errors
Water depth	Water depth is the distance between the water surface and the bottom of the water body at a specific location specified by the site location and offset.
Water depth, averaged	Water depth averaged over a channel cross-section or water body.  Averaging method to be specified in methods.
Water flux	Water Flux
Water potential	Water potential is the potential energy of water relative to pure free water (e.g. deionized water) in reference conditions. It quantifies the tendency of water to move from one area to another due to osmosis, gravity, mechanical pressure, or matrix effects including surface tension.
Water vapor density	Water vapor density
Wave height	The height of a surface wave, measured as the difference in elevation between the wave crest and an adjacent trough.
Weather conditions	Weather conditions
Well flow rate	Flow rate from well while pumping
Wellhead pressure	The pressure exerted by the fluid at the wellhead or casinghead after the well has been shut off for a period of time, typically 24 hours
Wind chill	The effect of wind on the temperature felt on human skin.
Wind direction	Wind direction
Wind gust direction	Direction of gusts of wind
Water Level	Water level relative to datum. The datum may be local or global such as NGVD 1929 and should be specified in the method description for associated data values.
\.


--
-- Data for Name: Variables; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."Variables" ("VariableID", "VariableCode", "VariableName", "Speciation", "VariableUnitsID", "SampleMedium", "ValueType", "IsRegular", "TimeSupport", "TimeUnitsID", "DataType", "GeneralCategory", "NoDataValue") FROM stdin;
11	44e5a2da-f6f8-3348-8372-4462d13daa94	Precipitation	Not Applicable	0	\N	\N	t	\N	\N	\N	\N	\N
\.


--
-- Name: Variables_VariableID_seq; Type: SEQUENCE SET; Schema: public; Owner: wmlclient
--

SELECT pg_catalog.setval('public."Variables_VariableID_seq"', 15, true);


--
-- Data for Name: VerticalDatumCV; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public."VerticalDatumCV" ("Term", "Definition") FROM stdin;
MSL	Mean Sea Level
NAVD88	North American Vertical Datum of 1988
NGVD29	National Geodetic Vertical Datum of 1929
Unknown	The vertical datum is unknown
\.


--
-- Data for Name: series_catalog_w_geom; Type: TABLE DATA; Schema: public; Owner: wmlclient
--

COPY public.series_catalog_w_geom ("SeriesID", "SiteID", "SiteCode", "SiteName", "SiteType", "VariableID", "VariableCode", "VariableName", "Speciation", "VariableUnitsID", "VariableUnitsName", "SampleMedium", "ValueType", "TimeSupport", "TimeUnitsID", "TimeUnitsName", "DataType", "GeneralCategory", "MethodID", "MethodDescription", "SourceID", "Organization", "SourceDescription", "Citation", "QualityControlLevelID", "QualityControlLevelCode", "BeginDateTime", "EndDateTime", "BeginDateTimeUTC", "EndDateTimeUTC", "ValueCount", "Geometry") FROM stdin;
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: leyden
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: us_gaz; Type: TABLE DATA; Schema: public; Owner: leyden
--

COPY public.us_gaz (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: us_lex; Type: TABLE DATA; Schema: public; Owner: leyden
--

COPY public.us_lex (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: us_rules; Type: TABLE DATA; Schema: public; Owner: leyden
--

COPY public.us_rules (id, rule, is_custom) FROM stdin;
\.


--
-- Data for Name: geocode_settings; Type: TABLE DATA; Schema: tiger; Owner: leyden
--

COPY tiger.geocode_settings (name, setting, unit, category, short_desc) FROM stdin;
\.


--
-- Data for Name: pagc_gaz; Type: TABLE DATA; Schema: tiger; Owner: leyden
--

COPY tiger.pagc_gaz (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_lex; Type: TABLE DATA; Schema: tiger; Owner: leyden
--

COPY tiger.pagc_lex (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_rules; Type: TABLE DATA; Schema: tiger; Owner: leyden
--

COPY tiger.pagc_rules (id, rule, is_custom) FROM stdin;
\.


--
-- Data for Name: topology; Type: TABLE DATA; Schema: topology; Owner: leyden
--

COPY topology.topology (id, name, srid, "precision", hasz) FROM stdin;
\.


--
-- Data for Name: layer; Type: TABLE DATA; Schema: topology; Owner: leyden
--

COPY topology.layer (topology_id, layer_id, schema_name, table_name, feature_column, feature_type, level, child_id) FROM stdin;
\.


--
-- Name: CensorCodeCV CensorCodeCV_pkey; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."CensorCodeCV"
    ADD CONSTRAINT "CensorCodeCV_pkey" PRIMARY KEY ("Term");


--
-- Name: DataTypeCV DataTypeCV_pkey; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."DataTypeCV"
    ADD CONSTRAINT "DataTypeCV_pkey" PRIMARY KEY ("Term");


--
-- Name: DataValues DataValues_DataValue_ValueAccuracy_LocalDateTime_UTCOffset__key; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_DataValue_ValueAccuracy_LocalDateTime_UTCOffset__key" UNIQUE ("DataValue", "ValueAccuracy", "LocalDateTime", "UTCOffset", "DateTimeUTC", "SiteID", "VariableID", "OffsetValue", "OffsetTypeID", "CensorCode", "QualifierID", "MethodID", "SourceID", "SampleID", "DerivedFromID", "QualityControlLevelID");


--
-- Name: DataValues DataValues_SiteID_VariableID_SourceID_DateTimeUTC_key; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_SiteID_VariableID_SourceID_DateTimeUTC_key" UNIQUE ("SiteID", "VariableID", "SourceID", "DateTimeUTC");


--
-- Name: DataValues DataValues_pkey; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_pkey" PRIMARY KEY ("ValueID");


--
-- Name: FeatureTypeCV FeatureTypeCV_FeatureTypeID_key; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."FeatureTypeCV"
    ADD CONSTRAINT "FeatureTypeCV_FeatureTypeID_key" UNIQUE ("FeatureTypeID");


--
-- Name: FeatureTypeCV FeatureTypeCV_FeatureTypeName_key; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."FeatureTypeCV"
    ADD CONSTRAINT "FeatureTypeCV_FeatureTypeName_key" UNIQUE ("FeatureTypeName");


--
-- Name: FeatureTypeCV FeatureTypeCV_pkey; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."FeatureTypeCV"
    ADD CONSTRAINT "FeatureTypeCV_pkey" PRIMARY KEY ("FeatureTypeID");


--
-- Name: GeneralCategoryCV GeneralCategoryCV_pkey; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."GeneralCategoryCV"
    ADD CONSTRAINT "GeneralCategoryCV_pkey" PRIMARY KEY ("Term");


--
-- Name: GroupDescriptions GroupDescriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."GroupDescriptions"
    ADD CONSTRAINT "GroupDescriptions_pkey" PRIMARY KEY ("GroupID");


--
-- Name: ISOMetadata ISOMetadata_pkey; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."ISOMetadata"
    ADD CONSTRAINT "ISOMetadata_pkey" PRIMARY KEY ("MetadataID");


--
-- Name: LabMethods LabMethods_pkey; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."LabMethods"
    ADD CONSTRAINT "LabMethods_pkey" PRIMARY KEY ("LabMethodID");


--
-- Name: Methods Methods_MethodCode_key; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Methods"
    ADD CONSTRAINT "Methods_MethodCode_key" UNIQUE ("MethodCode");


--
-- Name: Methods Methods_pkey; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Methods"
    ADD CONSTRAINT "Methods_pkey" PRIMARY KEY ("MethodID");


--
-- Name: OffsetTypes OffsetTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."OffsetTypes"
    ADD CONSTRAINT "OffsetTypes_pkey" PRIMARY KEY ("OffsetTypeID");


--
-- Name: Qualifiers Qualifiers_pkey; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Qualifiers"
    ADD CONSTRAINT "Qualifiers_pkey" PRIMARY KEY ("QualifierID");


--
-- Name: QualityControlLevels QualityControlLevels_pkey; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."QualityControlLevels"
    ADD CONSTRAINT "QualityControlLevels_pkey" PRIMARY KEY ("QualityControlLevelID");


--
-- Name: SampleMediumCV SampleMediumCV_pkey; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."SampleMediumCV"
    ADD CONSTRAINT "SampleMediumCV_pkey" PRIMARY KEY ("Term");


--
-- Name: SampleTypeCV SampleTypeCV_pkey; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."SampleTypeCV"
    ADD CONSTRAINT "SampleTypeCV_pkey" PRIMARY KEY ("Term");


--
-- Name: Samples Samples_pkey; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Samples"
    ADD CONSTRAINT "Samples_pkey" PRIMARY KEY ("SampleID");


--
-- Name: SeriesCatalog SeriesCatalog_SiteID_VariableID_key; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."SeriesCatalog"
    ADD CONSTRAINT "SeriesCatalog_SiteID_VariableID_key" UNIQUE ("SiteID", "VariableID");


--
-- Name: SeriesCatalog SeriesCatalog_pkey; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."SeriesCatalog"
    ADD CONSTRAINT "SeriesCatalog_pkey" PRIMARY KEY ("SeriesID");


--
-- Name: SiteTypeCV SiteTypeCV_pkey; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."SiteTypeCV"
    ADD CONSTRAINT "SiteTypeCV_pkey" PRIMARY KEY ("Term");


--
-- Name: Sites Sites_SiteCode_key; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Sites"
    ADD CONSTRAINT "Sites_SiteCode_key" UNIQUE ("SiteCode");


--
-- Name: Sites Sites_pkey; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Sites"
    ADD CONSTRAINT "Sites_pkey" PRIMARY KEY ("SiteID");


--
-- Name: Sources Sources_SourceCode_key; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Sources"
    ADD CONSTRAINT "Sources_SourceCode_key" UNIQUE ("SourceCode");


--
-- Name: Sources Sources_pkey; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Sources"
    ADD CONSTRAINT "Sources_pkey" PRIMARY KEY ("SourceID");


--
-- Name: SpatialReferences SpatialReferences_pkey; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."SpatialReferences"
    ADD CONSTRAINT "SpatialReferences_pkey" PRIMARY KEY ("SpatialReferenceID");


--
-- Name: SpeciationCV SpeciationCV_pkey; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."SpeciationCV"
    ADD CONSTRAINT "SpeciationCV_pkey" PRIMARY KEY ("Term");


--
-- Name: TopicCategoryCV TopicCategoryCV_pkey; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."TopicCategoryCV"
    ADD CONSTRAINT "TopicCategoryCV_pkey" PRIMARY KEY ("Term");


--
-- Name: Units Units_pkey; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Units"
    ADD CONSTRAINT "Units_pkey" PRIMARY KEY ("UnitsID");


--
-- Name: ValueTypeCV ValueTypeCV_pkey; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."ValueTypeCV"
    ADD CONSTRAINT "ValueTypeCV_pkey" PRIMARY KEY ("Term");


--
-- Name: VariableNameCV VariableNameCV_pkey; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."VariableNameCV"
    ADD CONSTRAINT "VariableNameCV_pkey" PRIMARY KEY ("Term");


--
-- Name: Variables Variables_VariableCode_key; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_VariableCode_key" UNIQUE ("VariableCode");


--
-- Name: Variables Variables_pkey; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_pkey" PRIMARY KEY ("VariableID");


--
-- Name: VerticalDatumCV VerticalDatumCV_pkey; Type: CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."VerticalDatumCV"
    ADD CONSTRAINT "VerticalDatumCV_pkey" PRIMARY KEY ("Term");


--
-- Name: Sites geom_default; Type: TRIGGER; Schema: public; Owner: wmlclient
--

CREATE TRIGGER geom_default BEFORE INSERT ON public."Sites" FOR EACH ROW WHEN (((new."Geometry" IS NULL) AND (new."Longitude" IS NOT NULL) AND (new."Latitude" IS NOT NULL))) EXECUTE PROCEDURE public.trg_geom_default();


--
-- Name: Categories Categories_VariableID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Categories"
    ADD CONSTRAINT "Categories_VariableID_fkey" FOREIGN KEY ("VariableID") REFERENCES public."Variables"("VariableID");


--
-- Name: DataValues DataValues_CensorCode_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_CensorCode_fkey" FOREIGN KEY ("CensorCode") REFERENCES public."CensorCodeCV"("Term");


--
-- Name: DataValues DataValues_MethodID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_MethodID_fkey" FOREIGN KEY ("MethodID") REFERENCES public."Methods"("MethodID");


--
-- Name: DataValues DataValues_OffsetTypeID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_OffsetTypeID_fkey" FOREIGN KEY ("OffsetTypeID") REFERENCES public."OffsetTypes"("OffsetTypeID");


--
-- Name: DataValues DataValues_QualifierID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_QualifierID_fkey" FOREIGN KEY ("QualifierID") REFERENCES public."Qualifiers"("QualifierID");


--
-- Name: DataValues DataValues_QualityControlLevelID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_QualityControlLevelID_fkey" FOREIGN KEY ("QualityControlLevelID") REFERENCES public."QualityControlLevels"("QualityControlLevelID");


--
-- Name: DataValues DataValues_SampleID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_SampleID_fkey" FOREIGN KEY ("SampleID") REFERENCES public."Samples"("SampleID");


--
-- Name: DataValues DataValues_SiteID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_SiteID_fkey" FOREIGN KEY ("SiteID") REFERENCES public."Sites"("SiteID") ON UPDATE CASCADE;


--
-- Name: DataValues DataValues_SourceID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_SourceID_fkey" FOREIGN KEY ("SourceID") REFERENCES public."Sources"("SourceID");


--
-- Name: DataValues DataValues_VariableID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_VariableID_fkey" FOREIGN KEY ("VariableID") REFERENCES public."Variables"("VariableID");


--
-- Name: DerivedFrom DerivedFrom_ValueID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."DerivedFrom"
    ADD CONSTRAINT "DerivedFrom_ValueID_fkey" FOREIGN KEY ("ValueID") REFERENCES public."DataValues"("ValueID");


--
-- Name: Groups Groups_GroupID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Groups"
    ADD CONSTRAINT "Groups_GroupID_fkey" FOREIGN KEY ("GroupID") REFERENCES public."GroupDescriptions"("GroupID");


--
-- Name: Groups Groups_ValueID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Groups"
    ADD CONSTRAINT "Groups_ValueID_fkey" FOREIGN KEY ("ValueID") REFERENCES public."DataValues"("ValueID");


--
-- Name: ISOMetadata ISOMetadata_TopicCategory_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."ISOMetadata"
    ADD CONSTRAINT "ISOMetadata_TopicCategory_fkey" FOREIGN KEY ("TopicCategory") REFERENCES public."TopicCategoryCV"("Term");


--
-- Name: OffsetTypes OffsetTypes_OffsetUnitsID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."OffsetTypes"
    ADD CONSTRAINT "OffsetTypes_OffsetUnitsID_fkey" FOREIGN KEY ("OffsetUnitsID") REFERENCES public."Units"("UnitsID");


--
-- Name: Samples Samples_LabMethodID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Samples"
    ADD CONSTRAINT "Samples_LabMethodID_fkey" FOREIGN KEY ("LabMethodID") REFERENCES public."LabMethods"("LabMethodID");


--
-- Name: Samples Samples_SampleType_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Samples"
    ADD CONSTRAINT "Samples_SampleType_fkey" FOREIGN KEY ("SampleType") REFERENCES public."SampleTypeCV"("Term");


--
-- Name: SeriesCatalog SeriesCatalog_SiteID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."SeriesCatalog"
    ADD CONSTRAINT "SeriesCatalog_SiteID_fkey" FOREIGN KEY ("SiteID") REFERENCES public."Sites"("SiteID");


--
-- Name: SeriesCatalog SeriesCatalog_VariableID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."SeriesCatalog"
    ADD CONSTRAINT "SeriesCatalog_VariableID_fkey" FOREIGN KEY ("VariableID") REFERENCES public."Variables"("VariableID");


--
-- Name: Sites Sites_FeatureType_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Sites"
    ADD CONSTRAINT "Sites_FeatureType_fkey" FOREIGN KEY ("FeatureType") REFERENCES public."FeatureTypeCV"("FeatureTypeName");


--
-- Name: Sites Sites_LatLongDatumID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Sites"
    ADD CONSTRAINT "Sites_LatLongDatumID_fkey" FOREIGN KEY ("LatLongDatumID") REFERENCES public."SpatialReferences"("SpatialReferenceID");


--
-- Name: Sites Sites_LocalProjectionID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Sites"
    ADD CONSTRAINT "Sites_LocalProjectionID_fkey" FOREIGN KEY ("LocalProjectionID") REFERENCES public."SpatialReferences"("SpatialReferenceID");


--
-- Name: Sites Sites_SiteType_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Sites"
    ADD CONSTRAINT "Sites_SiteType_fkey" FOREIGN KEY ("SiteType") REFERENCES public."SiteTypeCV"("Term");


--
-- Name: Sites Sites_VerticalDatum_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Sites"
    ADD CONSTRAINT "Sites_VerticalDatum_fkey" FOREIGN KEY ("VerticalDatum") REFERENCES public."VerticalDatumCV"("Term");


--
-- Name: Sources Sources_MetadataID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Sources"
    ADD CONSTRAINT "Sources_MetadataID_fkey" FOREIGN KEY ("MetadataID") REFERENCES public."ISOMetadata"("MetadataID");


--
-- Name: Variables Variables_DataType_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_DataType_fkey" FOREIGN KEY ("DataType") REFERENCES public."DataTypeCV"("Term");


--
-- Name: Variables Variables_GeneralCategory_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_GeneralCategory_fkey" FOREIGN KEY ("GeneralCategory") REFERENCES public."GeneralCategoryCV"("Term");


--
-- Name: Variables Variables_SampleMedium_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_SampleMedium_fkey" FOREIGN KEY ("SampleMedium") REFERENCES public."SampleMediumCV"("Term");


--
-- Name: Variables Variables_Speciation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_Speciation_fkey" FOREIGN KEY ("Speciation") REFERENCES public."SpeciationCV"("Term");


--
-- Name: Variables Variables_TimeUnitsID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_TimeUnitsID_fkey" FOREIGN KEY ("TimeUnitsID") REFERENCES public."Units"("UnitsID");


--
-- Name: Variables Variables_ValueType_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_ValueType_fkey" FOREIGN KEY ("ValueType") REFERENCES public."ValueTypeCV"("Term");


--
-- Name: Variables Variables_VariableName_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_VariableName_fkey" FOREIGN KEY ("VariableName") REFERENCES public."VariableNameCV"("Term");


--
-- Name: Variables Variables_VariableUnitsID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wmlclient
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_VariableUnitsID_fkey" FOREIGN KEY ("VariableUnitsID") REFERENCES public."Units"("UnitsID");


--
-- PostgreSQL database dump complete
--

