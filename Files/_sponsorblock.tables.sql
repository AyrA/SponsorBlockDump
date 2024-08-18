BEGIN TRANSACTION;

-- Drop existing indexes
DROP INDEX IF EXISTS "categoryIndex_UUID";
DROP INDEX IF EXISTS "lockCategories_hashedVideoID";
DROP INDEX IF EXISTS "lockCategories_videoID";
DROP INDEX IF EXISTS "ratings_hashedVideoID";
DROP INDEX IF EXISTS "ratings_videoID";
DROP INDEX IF EXISTS "sponsorTimes_hashedVideoID";
DROP INDEX IF EXISTS "sponsorTimes_userID";
DROP INDEX IF EXISTS "sponsorTimes_videoID";
DROP INDEX IF EXISTS "thumbnails_hashedVideoID";
DROP INDEX IF EXISTS "thumbnails_videoID";
DROP INDEX IF EXISTS "titles_UUID";
DROP INDEX IF EXISTS "unlistedVideos_videoID";
DROP INDEX IF EXISTS "userNames_userName";
DROP INDEX IF EXISTS "warnings_issuerUserID";
DROP INDEX IF EXISTS "warnings_userID";

-- Drop existing tables
DROP TABLE IF EXISTS "categoryVotes";
DROP TABLE IF EXISTS "lockCategories";
DROP TABLE IF EXISTS "ratings";
DROP TABLE IF EXISTS "sponsorTimes";
DROP TABLE IF EXISTS "thumbnailTimestamps";
DROP TABLE IF EXISTS "thumbnailVotes";
DROP TABLE IF EXISTS "thumbnails";
DROP TABLE IF EXISTS "titleVotes";
DROP TABLE IF EXISTS "titles";
DROP TABLE IF EXISTS "unlistedVideos";
DROP TABLE IF EXISTS "userNames";
DROP TABLE IF EXISTS "videoInfo";
DROP TABLE IF EXISTS "vipUsers";
DROP TABLE IF EXISTS "warnings";
COMMIT;

-- Create new tables
BEGIN TRANSACTION;
CREATE TABLE "categoryVotes" (
	"UUID"	TEXT NOT NULL,
	"category"	TEXT NOT NULL,
	"votes"	INTEGER NOT NULL,
	"id"	INTEGER NOT NULL UNIQUE,
	PRIMARY KEY("id")
);
CREATE TABLE "lockCategories" (
	"videoID"	TEXT NOT NULL,
	"userID"	TEXT NOT NULL,
	"actionType"	TEXT NOT NULL,
	"category"	TEXT NOT NULL,
	"hashedVideoID"	TEXT NOT NULL,
	"reason"	TEXT,
	"service"	TEXT NOT NULL,
	"id"	INTEGER NOT NULL UNIQUE,
	PRIMARY KEY("id")
);
CREATE TABLE "ratings" (
	"videoID"	TEXT NOT NULL,
	"service"	TEXT NOT NULL,
	"type"	INTEGER NOT NULL,
	"count"	INTEGER NOT NULL,
	"hashedVideoID"	TEXT NOT NULL,
	"id"	INTEGER NOT NULL UNIQUE,
	PRIMARY KEY("id")
);
CREATE TABLE "sponsorTimes" (
	"videoID"	TEXT NOT NULL,
	"startTime"	REAL NOT NULL,
	"endTime"	REAL NOT NULL,
	"votes"	INTEGER NOT NULL,
	"locked"	INTEGER NOT NULL,
	"incorrectVotes"	INTEGER NOT NULL,
	"UUID"	TEXT NOT NULL,
	"userID"	TEXT NOT NULL,
	"timeSubmitted"	INTEGER NOT NULL,
	"views"	INTEGER NOT NULL,
	"category"	TEXT NOT NULL,
	"actionType"	TEXT NOT NULL,
	"service"	TEXT NOT NULL,
	"videoDuration"	REAL NOT NULL,
	"hidden"	INTEGER NOT NULL,
	"reputation"	REAL NOT NULL,
	"shadowHidden"	INTEGER NOT NULL,
	"hashedVideoID"	TEXT NOT NULL,
	"userAgent"	TEXT,
	"description"	TEXT
);
CREATE TABLE "thumbnailTimestamps" (
	"UUID"	TEXT NOT NULL UNIQUE,
	"timestamp"	REAL NOT NULL,
	PRIMARY KEY("UUID")
);
CREATE TABLE "thumbnailVotes" (
	"UUID"	TEXT NOT NULL UNIQUE,
	"votes"	INTEGER NOT NULL,
	"locked"	INTEGER NOT NULL,
	"shadowHidden"	INTEGER NOT NULL,
	"downvotes"	INTEGER NOT NULL,
	"removed"	INTEGER NOT NULL,
	PRIMARY KEY("UUID")
);
CREATE TABLE "thumbnails" (
	"videoID"	TEXT NOT NULL,
	"original"	INTEGER NOT NULL,
	"userID"	TEXT NOT NULL,
	"service"	TEXT NOT NULL,
	"hashedVideoID"	TEXT NOT NULL,
	"timeSubmitted"	INTEGER NOT NULL,
	"UUID"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("UUID")
);
CREATE TABLE "titleVotes" (
	"UUID"	TEXT NOT NULL UNIQUE,
	"votes"	INTEGER NOT NULL,
	"locked"	INTEGER NOT NULL,
	"shadowHidden"	INTEGER NOT NULL,
	"verification"	INTEGER NOT NULL,
	"downvotes"	INTEGER NOT NULL,
	"removed"	INTEGER NOT NULL,
	PRIMARY KEY("UUID")
);
CREATE TABLE "titles" (
	"videoID"	TEXT NOT NULL,
	"title"	TEXT NOT NULL,
	"original"	INTEGER NOT NULL,
	"userId"	TEXT NOT NULL,
	"service"	TEXT NOT NULL,
	"hashedVideoID"	TEXT NOT NULL,
	"timeSubmitted"	INTEGER NOT NULL,
	"UUID"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("videoID","timeSubmitted")
);
CREATE TABLE "unlistedVideos" (
	"videoID"	TEXT NOT NULL,
	"year"	INTEGER,
	"views"	INTEGER,
	"channelID"	TEXT,
	"timeSubmitted"	INTEGER,
	"service"	TEXT,
	"id"	TEXT NOT NULL,
	PRIMARY KEY("id")
);
CREATE TABLE "userNames" (
	"userID"	TEXT NOT NULL,
	"userName"	TEXT,
	"locked"	INTEGER NOT NULL,
	PRIMARY KEY("userID")
);
CREATE TABLE "videoInfo" (
	"videoID"	TEXT NOT NULL UNIQUE,
	"channelID"	TEXT NOT NULL,
	"title"	TEXT NOT NULL,
	"published"	INTEGER NOT NULL,
	PRIMARY KEY("videoID")
);
CREATE TABLE "vipUsers" (
	"userID"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("userID")
);
CREATE TABLE "warnings" (
	"userID"	TEXT NOT NULL,
	"issueTime"	INTEGER NOT NULL,
	"issuerUserID"	TEXT NOT NULL,
	"enabled"	INTEGER NOT NULL,
	"reason"	TEXT,
	"type"	INTEGER NOT NULL
);
COMMIT;
