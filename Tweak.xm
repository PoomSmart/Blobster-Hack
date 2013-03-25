#import "substrate.h"
static BOOL add = YES;
// Very handy tool for adding Bonuses to Blob!
@interface DRBonusManager
+ (id)sharedManager;
- (void)addBonus:(int)arg1 fromTarget:(id)arg2;
@end
static id target;
// Its function for easirt writing
static void AddBonus(int type)
{
	[[%c(DRBonusManager) sharedManager] addBonus:type fromTarget:target];
	// For Future reference, value of type:
	// 1 = Blobule (Scaled Blob)
	// 2 = Un-Blobule
	// 3 = Upside-Down
	// 4 = ?
	// 5 = Super Speed (Orange Bonus)
	// 6 = Speed Boost (Red Arrow)
	// 7 = Angel
	// 8 = Shield
	// 9 = Swim Ring
	// 10 = Shrink
	// 11 = Water Blocker
}

static BOOL InfinityBlobHealth;
static BOOL WaterNoDie;
static BOOL HitMonsterWithoutDie;
static BOOL InfinityKey;
static BOOL AutoSR;
static BOOL AutoBlobule;
static BOOL AutoShield;
static BOOL AutoSuperSpeed;

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

- (void)setIsInvincible:(BOOL)arg1
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
	if (InfinityBlobHealth) { %orig(NO); }
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

- (void)setWaterIsLethal:(BOOL)arg1
{
	if (WaterNoDie) { %orig(NO); }
	else { %orig; }
}

- (void)setBlobIsInvincible:(BOOL)arg1
{
	if (InfinityBlobHealth) { %orig(YES); }
	else { %orig; }
}

- (void)applyDamage:(float)arg1
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
	if (WaterNoDie) { if (AutoSR) AddBonus(9); }
	else { %orig; }
}

- (void)startKinematicControlInPosition:(CGPoint)arg1 radius:(float)arg2
{
	%orig;
	if (AutoBlobule) {
		int i = 0;
		for (i = 0; i < 250; i++) {	AddBonus(1); } }
	if (AutoShield) {
		int i = 0;
		for (i = 0; i < 1; i++) { AddBonus(8); } }
	if (AutoSuperSpeed)	{
		int i = 0;
		for (i = 0; i < 1; i++) { AddBonus(5); } }
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

- (BOOL)blobIsKilled
{
	if (InfinityBlobHealth)
		return NO;
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

%hook DRBlobsterParticleNode

- (void)setBlobsterDeathUnderWater
{
	if (WaterNoDie) { }
	else { %orig; }
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

%hook DRBonusManager

- (void)addBonus:(int)arg1 fromTarget:(id)arg2
{
	id arg = arg2;
	target = arg;
	%orig(arg1, target);
}
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

- (void)dealloc { add = YES; %orig; }

%end

%end


static void loadHacks()
{
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.PS.BlobsterHack.plist"];
	id infinityblobhealth = [dict objectForKey:@"infinityBlobHealth"];
	id waternodie = [dict objectForKey:@"waterNoDie"];
	id hitmonsterwithoutdie = [dict objectForKey:@"hitMonsterWithoutDie"];
	id infinitykey = [dict objectForKey:@"infinityKey"];
	id autosr = [dict objectForKey:@"autoSR"];
	id autoblobule = [dict objectForKey:@"autoBlobule"];
	id autoshield = [dict objectForKey:@"autoShield"];
	id autosuperspeed = [dict objectForKey:@"autoSuperSpeed"];
	
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
	AutoSR = autosr ? [autosr boolValue] : YES;
	AutoBlobule = autoblobule ? [autoblobule boolValue] : YES;
	AutoShield = autoshield ? [autoshield boolValue] : YES;
	AutoSuperSpeed = autosuperspeed ? [autosuperspeed boolValue] : YES;
	
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