#import "substrate.h"
static BOOL InfinityBlobHealth;
static BOOL WaterNoDie;
static BOOL HitMonsterWithoutDie;
static BOOL InfinityKey;

static BOOL SuckerIsSuck;
static BOOL MonsterNoAmmo;
static BOOL MonsterStupid;
static BOOL EasyKillMonster;
static BOOL SpikeyNoSpike;
static BOOL OneHitKill;

static BOOL KillCrusher;

static int BonusValue;

static BOOL LargeScreen;
static BOOL AlwaysBonusLevel;
static BOOL TimeFreeze;
static BOOL RaceTimeFreeze;

// Relate with Monsters
%group monster

// No die when hit monsters
%hook DREnemy

- (BOOL)isHarmless
{
	if (HitMonsterWithoutDie)
		return YES;
	else
		return %orig;
}

// invincible = YES means you cannot kill monster by jumping over
- (BOOL)isInvincible
{ 
	if (EasyKillMonster)
		return NO;
	else
		return %orig;
}

- (void)setIsInvincible:(BOOL)invc
{
	if (EasyKillMonster)
		%orig(NO);
	else
		%orig;
}

%end

// Monster guy with bomb, no ammo
// Green
%hook DREnemyRangeBomb

- (void)shootAmmo
{
	if (MonsterNoAmmo) { }
	else { %orig; }
}

- (void)setAmmo:(id)arg1
{
	if (MonsterNoAmmo) { }
	else { %orig; }
}

- (void)addAmmo
{
	if (MonsterNoAmmo) { }
	else { %orig; }
}

- (BOOL)blobsterInRange
{
	if (MonsterStupid)
		return NO;
	else
		return %orig;
}

%end

// Red
%hook DREnemyRangeBombPoison

- (void)shootAmmo
{
	if (MonsterNoAmmo) { }
	else { %orig; }
}

- (void)addAmmo
{
	if (MonsterNoAmmo) { }
	else { %orig; }
}

%end

// Monsters guys can't see us
// Side Spike
%hook DREnemySideSpike

- (BOOL)blobsterInRange
{
	if (MonsterStupid)
		return NO;
	else
		return %orig;
}

%end

// Spikey (Green, Red)
%hook DREnemySpikey

- (BOOL)blobsterInRange
{
	if (MonsterStupid)
		return NO;
	else
		return %orig;
}

// Prevent spike from being executed
- (void)setEnemyState:(int)arg1
{
	if (SpikeyNoSpike) { }
	else { %orig; }
}

%end

// Sucker can't suck us
%hook DREnemySucker

- (void)setEnemyState:(int)arg1
{
	if (SuckerIsSuck) { }
	else { %orig; }
}

%end

%end


// Relate with player's Blob
%group blob

%hook DRBlobLayer

// Blob never die
- (void)setBlobIsKilled:(BOOL)arg1
{
	if (InfinityBlobHealth) { }
	else { %orig; }
}

- (void)killBlob
{
	if (InfinityBlobHealth) { }
	else { %orig; }
}

- (void)doKillBlob
{
	if (InfinityBlobHealth) { }
	else { %orig; }
}

// incase
- (void)killBlobNoParticles
{
	if (InfinityBlobHealth) { }
	else { %orig; }
}

// Blob never die in Water
- (void)killBlobInWater
{
	if (WaterNoDie) { }
	else { %orig; }
}

- (BOOL)waterIsLethal
{
	if (WaterNoDie)
		return NO;
	else
		return %orig;
}

// Blob is invincible
- (BOOL)blobIsInvincible
{
	if (OneHitKill)
		return YES;
	else
		return %orig;
}

// Infinity keys
- (BOOL)useKey
{
	if (InfinityKey)
		return YES;
	else
		return %orig;
}

%end

%end


%group object

%hook DRCrusherAction

- (void)execute:(float)arg1
{
	if (KillCrusher) { }
	else { %orig; }
}

%end

%end


%group bonus

%hook DRGame

- (int)bonusMultiplier { return BonusValue; }

%end

%end


%group gameplay

// Buggy
%hook DRDisplayEngine

- (BOOL)deviceIsHires
{
	if (LargeScreen)
		return NO;
	else
		return %orig;
}

%end

%hook DRGameLevel

// Any levels will be the bonus level
- (BOOL)isBonusLevel
{
	if (AlwaysBonusLevel)
		return YES;
	else
		return %orig;
}

// Freeze time
- (float)levelTime 
{ 
	if (TimeFreeze)
		return 0;
	else
		return %orig;
}

// Same but work in Race Mode
- (float)raceTimeRemaining
{
	if (RaceTimeFreeze)
		return 0;
	else
		return %orig;
}

%end

%end


static void loadHacks()
{
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.PS.BlobsterHack.plist"];
	id infinityblobhealth = [dict objectForKey:@"infinityBlobHealth"];
	id waternodie = [dict objectForKey:@"waterNoDie"];
	id hitmonsterwithoutdie = [dict objectForKey:@"hitMonsterWithoutDie"];
	id infinitykey = [dict objectForKey:@"infinityKey"];
	
	id suckerissuck = [dict objectForKey:@"suckerIsSuck"];
	id monsternoammo = [dict objectForKey:@"monsterNoAmmo"];
	id monsterstupid = [dict objectForKey:@"monsterStupid"];
	id easykillmonster = [dict objectForKey:@"easyKillMonster"];
	id spikeynospike = [dict objectForKey:@"spikeyNoSpike"];
	id onehitkill = [dict objectForKey:@"oneHitKill"];
	
	id killcrusher = [dict objectForKey:@"killCrusher"];
	
	int readBonusValue = [dict objectForKey:@"bonusValue"] ? [[dict objectForKey:@"bonusValue"] integerValue] : 1;
	
	id largescreen = [dict objectForKey:@"largeScreen"];
	id alwaysbonuslevel = [dict objectForKey:@"alwaysBonusLevel"];
	id timefreeze = [dict objectForKey:@"timeFreeze"];
	id racetimefreeze = [dict objectForKey:@"raceTimeFreeze"];

	InfinityBlobHealth = infinityblobhealth ? [infinityblobhealth boolValue] : YES;
	WaterNoDie = waternodie ? [waternodie boolValue] : YES;
	HitMonsterWithoutDie = hitmonsterwithoutdie ? [hitmonsterwithoutdie boolValue] : YES;
	InfinityKey = infinitykey ? [infinitykey boolValue] : YES;
	
	SuckerIsSuck = suckerissuck ? [suckerissuck boolValue] : YES;
	MonsterNoAmmo = monsternoammo ? [monsternoammo boolValue] : YES;
	MonsterStupid = monsterstupid ? [monsterstupid boolValue] : YES;
	EasyKillMonster = easykillmonster ? [easykillmonster boolValue] : YES;
	SpikeyNoSpike = spikeynospike ? [spikeynospike boolValue] : YES;
	OneHitKill = onehitkill ? [onehitkill boolValue] : YES;
	
	KillCrusher = killcrusher ? [killcrusher boolValue] : YES;
	
	if (readBonusValue < 1)
		readBonusValue = 1;
	if (readBonusValue != BonusValue)
		BonusValue = readBonusValue;
	
	LargeScreen = largescreen ? [largescreen boolValue] : YES;
	AlwaysBonusLevel = alwaysbonuslevel ? [alwaysbonuslevel boolValue] : YES;
	TimeFreeze = timefreeze ? [timefreeze boolValue] : YES;
	RaceTimeFreeze = racetimefreeze ? [racetimefreeze boolValue] : YES;

}

static void PostNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	loadHacks();
}

%ctor
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, PostNotification, CFSTR("com.PS.BlobsterHack.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	loadHacks();
	[pool drain];
	if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.chillingo.blobster"]) { %init(monster); %init(blob); %init(object); %init(bonus); %init(gameplay); }
}