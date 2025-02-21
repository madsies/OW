
# Global Vars

globalvar tick = 0
globalvar ANA_CHARGE_COST = 5

# Player vars

playervar chargedShot_ana = false
playervar playerStatusText = null
playervar player_cooldown_one = getTotalTimeElapsed()

# Subroutines 

def superJump():



# Rules

rule "super jump":
    @Event eachPlayer
    @Condition eventPlayer.isJumping()
    eventPlayer.startAcceleration(eventPlayer.getFacingDirection(), 50, 50, Relativity.TO_WORLD, AccelReeval.DIRECTION_RATE_AND_MAX_SPEED)
    waitUntil(eventPlayer.isOnGround(), 3)
    eventPlayer.stopAcceleration()


rule "ana setup":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.ANA
    @Hero ana
    eventPlayer.setAmmo(0, 69)

rule "chargeShot_ana":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.ANA
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    if (not(eventPlayer.chargedShot_ana) and eventPlayer.player_cooldown_one < getTotalTimeElapsed()+2):
        eventPlayer.setAmmo(0, eventPlayer.getAmmo(0) - ANA_CHARGE_COST)
        eventPlayer.chargedShot_ana = true
        hudSubtext(eventPlayer, "Charged shot", HudPosition.TOP, 2, Color.TEAM_1, HudReeval.NONE)
        eventPlayer.player_cooldown_one = getTotalTimeElapsed()

        
rule "fire_ana":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.ANA
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    if (eventPlayer.chargedShot_ana):
        wait(0.7) # Ana is a projectile hero, silly.
        eventPlayer.chargedShot_ana = false
        destroyAllHudTexts()

rule "fire_charge_ana":
    @Event playerDealtDamage
    @Condition eventPlayer.getCurrentHero() == Hero.ANA
    @Condition eventAbility() == Button.PRIMARY_FIRE
    if (eventPlayer.chargedShot_ana):
        victim.startDoT(eventPlayer, 1, 70)
        eventPlayer.chargedShot_ana = false
        destroyAllHudTexts()

rule "fire_charge_heal_ana":
    @Event playerDealtHealing
    @Condition eventPlayer.getCurrentHero() == Hero.ANA
    @Condition eventAbility() == Button.PRIMARY_FIRE
    if (eventPlayer.chargedShot_ana):
        healee.startHoT(eventPlayer, 1, 70)
        eventPlayer.chargedShot_ana = false
        destroyAllHudTexts()
        
