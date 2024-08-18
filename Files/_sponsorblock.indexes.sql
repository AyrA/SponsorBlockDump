BEGIN TRANSACTION;

-- Create new indexes
CREATE INDEX "categoryIndex_UUID" ON "categoryVotes" (
	"UUID"
);
CREATE INDEX "lockCategories_hashedVideoID" ON "lockCategories" (
	"hashedVideoID"	ASC
);
CREATE INDEX "lockCategories_videoID" ON "lockCategories" (
	"videoID"
);
CREATE INDEX "ratings_hashedVideoID" ON "ratings" (
	"hashedVideoID"
);
CREATE INDEX "ratings_videoID" ON "ratings" (
	"videoID"
);
CREATE INDEX "sponsorTimes_hashedVideoID" ON "sponsorTimes" (
	"hashedVideoID"
);
CREATE INDEX "sponsorTimes_userID" ON "sponsorTimes" (
	"userID"
);
CREATE INDEX "sponsorTimes_videoID" ON "sponsorTimes" (
	"videoID"
);
CREATE INDEX "thumbnails_hashedVideoID" ON "thumbnails" (
	"hashedVideoID"
);
CREATE INDEX "thumbnails_videoID" ON "thumbnails" (
	"videoID"
);
CREATE UNIQUE INDEX "titles_UUID" ON "titles" (
	"UUID"
);
CREATE INDEX "unlistedVideos_videoID" ON "unlistedVideos" (
	"videoID"
);
CREATE INDEX "userNames_userName" ON "userNames" (
	"userName"
);
CREATE INDEX "warnings_issuerUserID" ON "warnings" (
	"issuerUserID"
);
CREATE INDEX "warnings_userID" ON "warnings" (
	"userID"
);
COMMIT;
