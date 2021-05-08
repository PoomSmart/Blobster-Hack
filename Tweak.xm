#import <substrate.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>

static BOOL add = YES;

// Very handy tool for adding Bonuses to Blob!
@interface DRBonusManager
+ (instancetype)sharedManager;
- (void)addBonus:(int)bonus fromTarget:(id)arg2;
@end

static id target;
// Its function for easier writing
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

- (BOOL)isHarmless {
    return HitMonsterWithoutDie ? YES : %orig;
}

// invincible = YES means you cannot kill monster by jumping over
- (BOOL)isInvincible {
    return EasyKillMonster ? NO : %orig;
}

- (void)setIsInvincible:(BOOL)invincible {
    %orig(EasyKillMonster ? NO : invincible);
}

%end

// Monster guy with bomb, no ammo
// Green
%hook DREnemyRangeBomb

- (void)shootAmmo {
    if (MonsterNoAmmo) return;
    %orig;
}

- (void)setAmmo:(id)arg1 {
    if (MonsterNoAmmo) return;
    %orig;
}

- (void)addAmmo {
    if (MonsterNoAmmo) return;
    %orig;
}

- (BOOL)blobsterInRange {
    return MonsterStupid ? NO : %orig;
}

%end

// Red
%hook DREnemyRangeBombPoison

- (void)shootAmmo {
    if (MonsterNoAmmo) return;
    %orig;
}

- (void)addAmmo {
    if (MonsterNoAmmo) return;
    %orig;
}

%end

// Monsters guys can't see us
// Side Spike
%hook DREnemySideSpike

- (BOOL)blobsterInRange {
    return MonsterStupid ? NO : %orig;
}

%end

// Spikey (Green, Red)
%hook DREnemySpikey

- (BOOL)blobsterInRange {
    return MonsterStupid ? NO : %orig;
}

// Prevent spike from being executed
- (void)setEnemyState:(int)state {
    if (SpikeyNoSpike) return;
    %orig;
}

%end

// Sucker can't suck us
%hook DREnemySucker

- (void)setEnemyState:(int)state {
    if (SuckerIsSuck) return;
    %orig;
}

%end

%end

// Relate with player's Blob
%group blob

%hook DRBlobLayer

// Blob never die
- (void)setBlobIsKilled:(BOOL)killed {
    %orig(InfinityBlobHealth ? NO : killed);
}

- (void)killBlob {
    if (InfinityBlobHealth) return;
    %orig;
}

- (void)doKillBlob {
    if (InfinityBlobHealth) return;
    %orig;
}

- (void)setWaterIsLethal:(BOOL)lethal {
    %orig(WaterNoDie ? NO : lethal);
}

- (void)setBlobIsInvincible:(BOOL)invincible {
    %orig(InfinityBlobHealth ? YES : invincible);
}

- (void)applyDamage:(CGFloat)damage {
    if (InfinityBlobHealth) return;
    %orig;
}

// Just in case
- (void)killBlobNoParticles {
    if (InfinityBlobHealth) return;
    %orig;
}

// Blob never die in Water
- (void)killBlobInWater {
    if (WaterNoDie) {
        if (AutoSR) AddBonus(9);
        return;
    }
    %orig;
}

- (void)startKinematicControlInPosition:(CGPoint)arg1 radius:(CGFloat)radius {
    %orig;
    if (AutoBlobule) {
        for (int i = 0; i < 250; i++) {
            AddBonus(1);
        }
    }
    if (AutoShield)
        AddBonus(8);
    if (AutoSuperSpeed)
        AddBonus(5);
}

- (BOOL)waterIsLethal {
    return WaterNoDie ? NO : %orig;
}

// Blob is invincible
- (BOOL)blobIsInvincible {
    return OneHitKill ? YES : %orig;
}

- (BOOL)blobIsKilled {
    return InfinityBlobHealth ? NO : %orig;
}

// Infinity keys
- (BOOL)useKey {
    return InfinityKey ? YES : %orig;
}

%end

%hook DRBlobsterParticleNode

- (void)setBlobsterDeathUnderWater {
    if (WaterNoDie) return;
    %orig;
}

%end

%end

%group object

%hook DRCrusherAction

- (void)execute:(CGFloat)arg1 {
    if (KillCrusher) return;
    %orig;
}

%end

%end

%group bonus

%hook DRGame

- (int)bonusMultiplier {
    return BonusValue;
}

%end

%hook DRBonusManager

- (void)addBonus:(int)bonus fromTarget:(id)arg2 {
	id arg = arg2;
	target = arg;
	%orig(bonus, target);
}

%end

%end

%group gameplay

// Buggy
%hook DRDisplayEngine

- (BOOL)deviceIsHires {
    return LargeScreen ? NO : %orig;
}

%end

%hook DRGameLevel

// Any levels will be the bonus level
- (BOOL)isBonusLevel {
    return AlwaysBonusLevel ? YES : %orig;
}

// Freeze time
- (CGFloat)levelTime {
    return TimeFreeze ? 0 : %orig;
}

// Same but work in Race Mode
- (CGFloat)raceTimeRemaining {
    return RaceTimeFreeze ? 0 : %orig;
}

- (void)dealloc {
    add = YES;
    %orig;
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

    InfinityBlobHealth = [infinityblobhealth boolValue];
    WaterNoDie = [waternodie boolValue];
    HitMonsterWithoutDie = [hitmonsterwithoutdie boolValue];
    InfinityKey = [infinitykey boolValue];
    AutoSR = [autosr boolValue];
    AutoBlobule = [autoblobule boolValue];
    AutoShield = [autoshield boolValue];
    AutoSuperSpeed = [autosuperspeed boolValue];
    
    SuckerIsSuck = [suckerissuck boolValue];
    MonsterNoAmmo = [monsternoammo boolValue];
    MonsterStupid = [monsterstupid boolValue];
    EasyKillMonster = [easykillmonster boolValue];
    SpikeyNoSpike = [spikeynospike boolValue];
    OneHitKill = [onehitkill boolValue];
    
    KillCrusher = [killcrusher boolValue];
    
    if (readBonusValue < 1)
        readBonusValue = 1;
    if (readBonusValue != BonusValue)
        BonusValue = readBonusValue;
    
    LargeScreen = [largescreen boolValue];
    AlwaysBonusLevel = [alwaysbonuslevel boolValue];
    TimeFreeze = [timefreeze boolValue];
    RaceTimeFreeze = [racetimefreeze boolValue];
}

static void PostNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    loadHacks();
}

%ctor {
    @autoreleasepool {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, PostNotification, CFSTR("com.PS.BlobsterHack.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
        loadHacks();
        %init(monster);
        %init(blob);
        %init(object);
        %init(bonus);
        %init(gameplay);
    }
}
