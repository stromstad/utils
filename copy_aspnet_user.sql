DECLARE
	@FROM_DB VARCHAR(MAX) = 'epicms-inno01mstr6ub5lprod-2019-3-6-10-7',
	@TO_DB VARCHAR(MAX) = 'innovasjonnorge',
	@USER_ID VARCHAR(MAX) = 'A9F884E5-1217-4422-BEFE-8EB73EE4A59E',

	@COPY_USER_TEMPLATE VARCHAR(MAX),
	@COPY_ROLES_TEMPLATE VARCHAR(MAX),
	@COPY_PROFILE_TEMPLATE VARCHAR(MAX),
	@COPY_MEMBERSHIP_TEMPLATE VARCHAR(MAX)

SET @COPY_USER_TEMPLATE =
'INSERT INTO [{TODB}].[dbo].[aspnet_Users]	
    ([ApplicationId] ,[UserId] ,[UserName] ,[LoweredUserName] ,[MobileAlias] ,[IsAnonymous] ,[LastActivityDate])
	(SELECT [ApplicationId] ,[UserId] ,[UserName] ,[LoweredUserName] ,[MobileAlias] ,[IsAnonymous],[LastActivityDate] FROM [{FROMDB}].[dbo].aspnet_Users u WHERE u.UserId = ''{USERID}'')'

SET @COPY_ROLES_TEMPLATE =
'INSERT INTO [{TODB}].[dbo].[aspnet_UsersInRoles]
	([UserId],[RoleId])
	(SELECT [UserId], [RoleId] FROM [{FROMDB}].[dbo].[aspnet_UsersInRoles] uir WHERE uir.UserId = ''{USERID}'')'

SET @COPY_PROFILE_TEMPLATE =
'INSERT INTO [{TODB}].dbo.aspnet_Profile
	(UserId, PropertyNames, PropertyValuesString, PropertyValuesBinary, LastUpdatedDate)
	(SELECT p.UserId, p.PropertyNames, p.PropertyValuesString, p.PropertyValuesBinary, p.LastUpdatedDate FROM [{FROMDB}].[dbo].[aspnet_Profile] p WHERE p.UserId = ''{USERID}'')'

SET @COPY_MEMBERSHIP_TEMPLATE = 
'INSERT INTO [{TODB}].[dbo].[aspnet_Membership]
    ([ApplicationId] ,[UserId] ,[Password] ,[PasswordFormat] ,[PasswordSalt],[MobilePIN] ,[Email] ,[LoweredEmail] ,[PasswordQuestion] ,[PasswordAnswer] ,[IsApproved] ,[IsLockedOut]
    ,[CreateDate] ,[LastLoginDate] ,[LastPasswordChangedDate] ,[LastLockoutDate] ,[FailedPasswordAttemptCount] ,[FailedPasswordAttemptWindowStart],[FailedPasswordAnswerAttemptCount]
    ,[FailedPasswordAnswerAttemptWindowStart] ,[Comment])
	(SELECT           
    [ApplicationId] ,[UserId] ,[Password] ,[PasswordFormat] ,[PasswordSalt] ,[MobilePIN] ,[Email] ,[LoweredEmail] ,[PasswordQuestion] ,[PasswordAnswer] ,[IsApproved] ,[IsLockedOut]
    ,[CreateDate] ,[LastLoginDate] ,[LastPasswordChangedDate] ,[LastLockoutDate] ,[FailedPasswordAttemptCount] ,[FailedPasswordAttemptWindowStart] ,[FailedPasswordAnswerAttemptCount]
    ,[FailedPasswordAnswerAttemptWindowStart] ,[Comment] FROM [{FROMDB}].[dbo].[aspnet_Membership] dbOrig WHERE dbOrig.UserId = ''{USERID}'')'

DECLARE @COPY_USER_SCRIPT VARCHAR(MAX)
SET @COPY_USER_SCRIPT = REPLACE(REPLACE(REPLACE(@COPY_USER_TEMPLATE, '{USERID}', @USER_ID), '{TODB}', @TO_DB), '{FROMDB}', @FROM_DB)

DECLARE @COPY_ROLES_SCRIPT VARCHAR(MAX)
SET @COPY_ROLES_SCRIPT = REPLACE(REPLACE(REPLACE(@COPY_ROLES_TEMPLATE, '{USERID}', @USER_ID), '{TODB}', @TO_DB), '{FROMDB}', @FROM_DB)

DECLARE @COPY_PROFILE_SCRIPT VARCHAR(MAX)
SET @COPY_PROFILE_SCRIPT = REPLACE(REPLACE(REPLACE(@COPY_PROFILE_TEMPLATE, '{USERID}', @USER_ID), '{TODB}', @TO_DB), '{FROMDB}', @FROM_DB)

DECLARE @COPY_MEMBERSHIP_SCRIPT VARCHAR(MAX)
SET @COPY_MEMBERSHIP_SCRIPT = REPLACE(REPLACE(REPLACE(@COPY_MEMBERSHIP_TEMPLATE, '{USERID}', @USER_ID), '{TODB}', @TO_DB), '{FROMDB}', @FROM_DB)

EXECUTE(@COPY_USER_SCRIPT)
EXECUTE(@COPY_ROLES_SCRIPT)
EXECUTE(@COPY_PROFILE_SCRIPT)
EXECUTE(@COPY_MEMBERSHIP_SCRIPT)

GO


