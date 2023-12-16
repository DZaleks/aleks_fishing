Config = {}

Config.FishCooldown = 1000 * 20 -- Seconds
Config.BaitLoseChanceOnFail = 75 -- Chance to loose your bait on fail in percent
Config.FindChance = 75 -- Chance to find a fish per tick | Config.FishCooldown = 1 tick

Config.FishingrodItem = "fishingrod"
Config.FishbaitItem = "fishbait"

Config.DiscordWebhook = ""

Config.Fish = {
    {name = "tuna", displayName = "Tuna", luck = "15", difficulty = {'hard', 'medium', 'easy'}},
    {name = "salmon", displayName = "Salmon", luck = "20", difficulty = {'medium', 'easy'}},
    {name = "anchovy", displayName = "Anchovy", luck = "40", difficulty = {'easy', 'easy'}},
    {name = "trout", displayName = "Trout", luck = "15", difficulty = {'easy'}}
}