!function(global, module, define) {
    function escapeRegExp(string) {
        return string.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, "\\$&");
    }
    function escapeTags(tags, consumeWs) {
        if (!Array.isArray(tags) || 2 !== tags.length) throw new Error("Invalid tags: " + tags);
        return [ escapeRegExp(tags[0]) + (consumeWs ? "\\s*" : ""), (consumeWs ? "\\s*" : "") + escapeRegExp(tags[1]) ];
    }
    function mergeRecursive(obj1, obj2) {
        for (var p in obj2) if (obj2.hasOwnProperty(p)) try {
            obj2[p].constructor === Object ? obj1[p] = mergeRecursive(obj1[p], obj2[p]) : obj1[p] = obj2[p];
        } catch (e) {
            obj1[p] = obj2[p];
        }
        return obj1;
    }
    function randomItem(items) {
        return items[Math.floor(Math.random() * items.length)];
    }
    function objPropertyPath(obj, path, silent) {
        for (var arr = path.split("."); arr.length && (obj = obj[arr.shift()]); ) ;
        if (void 0 === obj && !silent) throw "Undefined property path: " + path;
        return obj;
    }
    var _babaGrammars = {}, Baba = global.Baba = {
        Parser: function(grammar, variables) {
            function parseGrammar(elements, args) {
                return "function" == typeof elements ? parseGrammar(elements.apply(this, [ _parser ].concat(args || []))) : "object" == typeof elements ? parseGrammar(randomItem(elements)) : "string" == typeof elements ? parseString(elements) : void 0;
            }
            function parseString(str) {
                var refTagRE = escapeTags(_grammar.tags.ref, !0), altTagRE = escapeTags(_grammar.tags.alt);
                return str = str.replace(new RegExp(refTagRE[0] + "(.+?)" + refTagRE[1], "g"), replaceRefTags), 
                str = str.replace(new RegExp(altTagRE[0] + "(.+?)" + altTagRE[1], "g"), replaceAltTags);
            }
            function replaceAltTags(m, $1) {
                var split = $1.split("|");
                return 1 === split.length && split.push(""), randomItem(split);
            }
            function replaceRefTags(m, $1) {
                var split = $1.match(/(\\.|[^\|])+/g), ref = split[0], transforms = split.slice(1, split.length), grammarParent = "", refStrMatch = ref.match(/^("|')(.+?)\1$/), refValue = "", refArgs = [], refToVariables = [], refSplit = ref.split("->");
                if (refSplit.length > 1 && (ref = refSplit[0], refToVariables = refSplit.slice(1, refSplit.length)), 
                "$" === ref[0]) {
                    var varNameSplit = ref.split(/\s+/g), key = varNameSplit[0].slice(1, varNameSplit[0].length), fallback = void 0 !== varNameSplit[1] ? varNameSplit[1] : null;
                    if (_variables.hasOwnProperty(key)) refValue = _variables[key]; else {
                        if (!fallback) throw "Undefined variable: $" + key;
                        refValue = objPropertyPath(_grammar.grammar, fallback), grammarParent = fallback.split(".")[0];
                    }
                } else if (refStrMatch) refValue = refStrMatch[2]; else {
                    var refData = ref.match(/^([\w\.\-]+)(\s*\((.*)\))?/);
                    if (refData[3]) {
                        var jsonArr = [];
                        try {
                            jsonArr = JSON.parse("[" + refData[3] + "]");
                        } catch (e) {
                            throw "JSON parse error: " + e;
                        }
                        ref = refData[1], refArgs = refArgs.concat(jsonArr);
                    }
                    refValue = objPropertyPath(_grammar.grammar, ref), grammarParent = ref.split(".")[0];
                }
                if (void 0 === (refValue = parseGrammar(refValue, refArgs))) throw "Invalid reference: " + $1;
                return refToVariables.forEach(function(key) {
                    _variables[key] = refValue;
                }), transforms.forEach(function(transform) {
                    refValue = applyTransform(refValue, transform, grammarParent);
                }), refValue = parseGrammar(refValue, refArgs);
            }
            function applyTransform(str, transform, grammarParent) {
                var transformToVariables = [], transformSplit = transform.split("->");
                transformSplit.length > 1 && (transform = transformSplit[0], transformToVariables = transformSplit.slice(1, transformSplit.length));
                var transformData = transform.match(/^([\w\.\-]+)(\s*\((.*)\))?$/), transformPath = "", callArgs = [ str ], transformedStr = "";
                if (transform = transformData[1], transformData[3]) try {
                    callArgs = callArgs.concat(JSON.parse("[" + transformData[3] + "]"));
                } catch (e) {
                    throw "JSON parse error: " + e;
                }
                if (objPropertyPath(_grammar.transforms, transform, !0)) transformPath = transform; else if (objPropertyPath(_grammar.transforms, [ "__common__", transform ].join("."), !0)) transformPath = [ "__common__", transform ].join("."); else {
                    if (!objPropertyPath(_grammar.transforms, [ grammarParent, transform ].join("."), !0)) throw "Invalid transformer: " + transform;
                    transformPath = [ grammarParent, transform ].join(".");
                }
                return transformedStr = objPropertyPath(_grammar.transforms, transformPath).apply(this, callArgs), 
                transformToVariables.forEach(function(key) {
                    _variables[key] = transformedStr;
                }), transformedStr;
            }
            if (!grammar) throw "No grammar provided";
            if (!_babaGrammars.hasOwnProperty(grammar)) throw "Grammar " + grammar + " not loaded";
            var _grammar = this.grammar = _babaGrammars[grammar], _variables = variables || {}, _parser = this;
            this.render = function(grammarPath) {
                return parseGrammar(objPropertyPath(_grammar.grammar, grammarPath) || "");
            }, this.setVariable = function(key, value) {
                _variables[key] = value;
            }, this.getVariable = function(key) {
                if (key && key.length) return "$" === key[0] && (key = key.slice(1, key.length)), 
                _variables[key];
            };
        },
        Grammar: function(name, refTags, altTags) {
            var _grammar = {
                name: name,
                transforms: {},
                grammar: {},
                tags: {
                    ref: refTags || [ "{{", "}}" ],
                    alt: altTags || [ "[[", "]]" ]
                }
            };
            _babaGrammars[name] = _grammar, this.addTransforms = function(transforms) {
                _grammar.transforms = mergeRecursive(_grammar.transforms, transforms);
            }, this.addGrammar = function(grammar) {
                _grammar.grammar = mergeRecursive(_grammar.grammar, grammar);
            }, this.require = function(name) {
                if (!_babaGrammars.hasOwnProperty(name)) throw "Invalid grammar: " + name;
                var requiredGrammar = _babaGrammars[name];
                this.addTransforms(requiredGrammar.transforms), this.addGrammar(requiredGrammar.grammar);
            };
        }
    };
    module && module.exports ? module.exports = Baba : define && define.amd && define(function() {
        return Baba;
    });
}(this, "object" == typeof module && module, "function" == typeof define && define), 
function(global, module, define) {
    function replaceRegexp(rules, str) {
        var ret;
        return rules.some(function(filter) {
            if (str.match(filter[0])) return ret = str.replace(filter[0], filter[1]), !0;
        }), ret;
    }
    function init(Baba) {
        new Baba.Grammar("common").addTransforms({
            __common__: {
                "prepend-an": function(str) {
                    return str[0].match(/[aeiou]/) ? "an " + str : "a " + str;
                },
                "uppercase-first": function(str) {
                    return str.substring(0, 1).toUpperCase() + str.substring(1, str.length);
                },
                uppercase: function(str) {
                    return str.toUpperCase();
                },
                lowercase: function(str) {
                    return str.toLowerCase();
                }
            },
            verb: {
                tense: {
                    past: replaceRegexp.bind(this, [ [ /^((re)?set)$/i, "$1" ], [ /^(send)$/i, "sent" ], [ /^(show)$/i, "shown" ], [ /^(checkout)$/i, "checked out" ], [ /(.*[^aeiouy][aeiouy])([bcdfglmpstvz])$/i, "$1$2$2ed" ], [ /(.*)e$/i, "$1ed" ], [ /(.*)y$/i, "$1ied" ], [ /(.*)/i, "$1ed" ] ]),
                    present: replaceRegexp.bind(this, [ [ /^(checkout)$/i, "checks out" ], [ /(.*)ex$/i, "$1exes" ], [ /(.*)([^aeo])y$/i, "$1$2ies" ], [ /(.*)([sc]h|s)$/i, "$1$2es" ], [ /(.*)/i, "$1s" ] ]),
                    "present-participle": replaceRegexp.bind(this, [ [ /^(checkout)$/i, "checking out" ], [ /(.*[^aeiouy][aeiouy])([bcdfglmpstvz])$/i, "$1$2$2ing" ], [ /(.*)e$/i, "$1ing" ], [ /(.*)$/i, "$1ing" ] ])
                },
                "-ize": replaceRegexp.bind(this, [ [ /(.*)[aeiouy]$/i, "$1ize" ], [ /(.*)$/i, "$1ize" ] ])
            },
            noun: {
                plural: replaceRegexp.bind(this, [ [ /(.*)man$/i, "$1men" ], [ /(womyn)$/i, "wymyn" ], [ /(person)$/i, "people" ], [ /(.*)ife$/i, "$1ives" ], [ /(.*)ex$/i, "$1ices" ], [ /(.*)([^ou])y$/i, "$1$2ies" ], [ /(.*)([sc]h|s)$/i, "$1$2es" ], [ /(.*)/i, "$1s" ] ])
            },
            adjective: {
                "-ity": replaceRegexp.bind(this, [ [ /(.*)eme$/i, "$1emacy" ], [ /(.*)([ia])ble$/i, "$1$2bility" ], [ /(.*)([tv])e$/i, "$1$2eness" ], [ /(.*)[aeiouy]$/i, "$1ity" ], [ /(.*)$/i, "$1ity" ] ]),
                "-ly": replaceRegexp.bind(this, [ [ /(.*)ic$/i, "$1ically" ], [ /(.*)[aeiouy]$/i, "$1y" ], [ /(.*)$/i, "$1ly" ] ])
            }
        });
    }
    "object" == typeof module && module.exports ? module.exports = init : "function" == typeof define && define.amd ? define(function() {
        return init;
    }) : init(global.Baba);
}(this, "undefined" != typeof module && module, "undefined" != typeof define && define), 
function(global, module, define) {
    function init(Baba) {
        var grammar = new Baba.Grammar("git-manual", [ "{", "}" ], [ "[", "]" ]);
        grammar.require("common"), grammar.addTransforms({
            __common__: {
                constantify: function(str) {
                    return str.toUpperCase().replace(/[^a-z0-9]/gi, "_");
                }
            }
        }), grammar.addGrammar({
            sentence: [ "{condition|uppercase-first}, {statement}.", "{condition|uppercase-first}, {statement}, {conclusion}.", "{statement|uppercase-first}.", "{statement|uppercase-first}, {conclusion}." ],
            paragraph: [ "{sentence} {sentence}", "{sentence} {sentence} {sentence}", "{sentence} {sentence} {sentence} {sentence}" ],
            verb: {
                git: "[add|allot|annotate|apply|archive|bisect|blame|branch|bundle|check|checkout|cherry-pick|clean|clone|commit|configure|count|describe|diff|export|fail|fast-export|fast-import|fetch|filter-branch|format-patch|forward-port|fsck|grep|import|index|initialize|log|merge|name|note|pack|parse|patch|perform|prevent|prune|pull|push|quiltimport|reapply|rebase|reflog|relink|remote|remove|repack|request|reset|reset|return|rev-list|rev-parse|revert|save|send|set|show|specify|stage|stash|strip]",
                common: "[abandon|abduct|abolish|abuse|accuse|acquire|activate|adapt|add|address|adjust|advise|aid|alert|allocate|answer|apprehend|approach|arbitrate|arrange|arrest|assault|assemble|assess|assign|assist|attack|attract|audit|augment|authenticate|authorize|automate|avoid|award|balance|bang|beat|berate|bite|blast|blend|block|blow|book|boost|brace|brief|brighten|buck|bump|bury|bushwhack|calculate|call|calm|cancel|capitalize|catch|centralize|certify|challenge|change|channel|charge|chart|chase|check|choke|circumscribe|circumvent|clap|clarify|classify|climb|clip|clutch|coach|collaborate|collapse|collate|collect|collide|combine|command|commandeer|compile|complete|compose|compute|conceive|condense|configure|conserve|consolidate|construct|consult|contract|control|convert|coordinate|correlate|counsel|count|cram|crash|create|cripple|critique|cultivate|cure|customize|cut|decorate|decrease|define|delegate|delete|delineate|deliver|demonstrate|derive|describe|design|detail|detect|determine|develop|devise|diagnose|dictate|direct|discard|discover|dispatch|display|dissect|distinguish|distribute|ditch|divert|dodge|dominate|dope|double|douse|draft|drag|drain|dramatize|drape|draw|dress|drill|drink|drop|drown|drug|dry|dunk|earn|edge|edit|educate|eject|elect|elevate|eliminate|employ|enable|enact|encourage|endure|engage|engineer|enjoin|ensnare|ensure|enter|equip|escalate|escape|establish|evacuate|evade|evaluate|evict|examine|execute|exhale|exhibit|exit|expand|expedite|expel|explode|experience|experiment|explain|explore|expose|extend|extirpate|extract|extricate|fade|fake|fashion|fear|feed|feel|fight|file|fill|find|finger|finish|fix|flag|flap|flash|flatten|flaunt|flay|flick|fling|flip|flog|flounder|flout|flush|focus|fondle|force|forecast|forge|formalize|form|formulate|fornicate|foster|found|fumble|fund|furnish|gain|gather|generate|gesture|get|give|gouge|govern|graduate|grab|grasp|greet|grind|grip|grope|ground|grow|guard|guide|gyrate|hack|hail|halt|halve|hammer|handle|hang|harass|hasten|haul|head|help|hide|hijack|hire|hit|hitch|hoist|hold|hug|hurl|hurtle|hypothesize|identify|ignore|illustrate|imitate|implement|improve|improvise|increase|index|indict|individualize|induce|inflict|influence|inform|initiate|inject|injure|insert|inspect|inspire|install|instigate|instruct|integrate|intensify|interchange|interpret|interview|introduce|invade|invent|investigate|isolate|itemize|jab|jam|jar|jerk|jimmy|jingle|jolt|judge|jump|justify|keel|keynote|kibitz|kick|kidnap|kill|knife|land|lash|launch|lead|leap|learn|lecture|lessen|level|license|lick|link|listen|locate|log|lower|make|maim|maintain|manage|mangle|manipulate|manufacture|mark|market|massage|master|maul|measure|mediate|meet|mend|mentor|mimic|minimize|mobilize|mock|model|molest|monitor|motivate|mourn|move|mumble|murder|muster|mutilate|nab|nag|nail|narrow|needle|negotiate|nick|nip|nominate|nurture|observe|obtain|occupy|offer|operate|order|organize|originate|outline|overcome|oversee|pack|paddle|page|panic|park|parry|pass|pat|patrol|pause|paw|peel|penetrate|perceive|perfect|perform|persuade|photograph|pick|picket|pile|pilot|pin|pinch|pioneer|pirate|pitch|place|plan|play|plow|plunge|pocket|poke|polish|pose|position|pounce|predict|prepare|prescribe|present|print|prioritize|probe|process|procure|prod|produce|program|project|promote|prompt|proofread|propel|propose|protect|prove|provide|provoke|publicize|publish|pull|pump|punch|purchase|purge|pursue|push|qualify|question|quicken|quit|quiz|race|raid|raise|ram|ransack|rate|rattle|ravage|read|realize|rebuild|receive|recommend|reconcile|record|recoup|recruit|redeem|reduce|refer|regain|regulate|reinforce|rejoin|relate|relax|relieve|remove|render|renew|renovate|reorganize|repair|repel|report|represent|repulse|research|resign|resist|resolve|respond|restore|retain|retaliate|retreat|retrieve|reveal|review|revise|ride|rip|risk|rob|rock|roll|rub|rush|salute|satisfy|save|saw|scale|scan|scare|scatter|scavenge|schedule|scold|scoop|score|scour|scout|scrape|scream|screen|screw|scrub|scruff|scuffle|sculpt|seal|search|secure|seduce|segment|seize|select|sell|sense|serve|service|set|sever|sew|shake|shanghai|shape|share|sharpen|shave|shear|shell|shield|shift|shock|shoot|shorten|shout|shove|shovel|show|shun|sidestep|signal|simplify|sip|skim|skip|skirt|slacken|slam|slap|slash|slay|slide|smack|smear|smell|smuggle|snap|snatch|sniff|snuggle|soak|soil|solve|sort|spear|spin|splice|split|spot|spread|stack|stamp|start|startle|steal|steer|stiffen|stifle|stimulate|stock|stomp|stop|strangle|strap|streamline|strengthen|stress|strike|strip|stroke|stub|study|stuff|stun|subdue|submerge|submit|suck|summarize|summon|supervise|support|surrender|survey|suspend|sustain|swagger|swallow|swap|swing|swipe|switch|synergize|synthesize|systematize|tabulate|tackle|take|tap|target|taste|taunt|teach|tear|tease|terrorize|test|thrash|thread|threaten|throw|tickle|tie|tighten|tilt|tip|toss|touch|tout|track|train|transcribe|transfer|transform|translate|transport|trap|tread|treat|trim|trip|triple|tuck|tug|tumble|turn|tutor|twist|type|uncover|understand|undertake|undo|undress|unfold|unify|unite|unravel|untangle|unwind|update|usher|utilize|vacate|validate|value|vanquish|vault|vent|verbalize|verify|violate|ward|watch|wave|weigh|whack|whip|whirl|whistle|widen|wield|wiggle|withdraw|work|wreck|wrench|wrestle|write|yank|yell|yelp|yield|zap|zip]",
                synonym: {
                    perform: "[perform|execute|apply]",
                    supply: "[supply|specify|set|define|provide]",
                    will: "[can|must|should|could|will]",
                    verify: "[control|verify|check]"
                }
            },
            noun: {
                git: "[archive|area|base|branch|change|commit|file|head|history|index|log|object|origin|pack|path|ref|remote|stage|stash|submodule|subtree|tag|tip|tree|upstream]",
                location: "[non-{verb.git|tense.past} |][applied|downstream|local|remote|staged|unstaged|upstream]",
                synonym: {
                    failure: "[failure|error]",
                    option: "[option|argument|flag]",
                    command: "[command|executable|action]"
                }
            },
            adjective: {
                "git-action": "[automatic|passive|temporary|staged]",
                synonym: {
                    possible: [ "possible", "a [{synonym.small-chance} |]likelihood", "a [{synonym.small-chance} |]chance" ],
                    relevant: "[relevant|applicable|appropriate|significant]"
                }
            },
            adverb: {
                synonym: {
                    immediately: "[immediately|during consolidation|during initialization|after pre-cataloging|during cataloging|prior to pre-cataloging|prior to pre-initialization|after pre-initialization|before consolidation]",
                    previously: "[previously|earlier|formerly|once]",
                    sometimes: "[when appropriate|in {determiner} cases]",
                    cleanly: "[un|][cleanly|successfully]"
                }
            },
            synonym: {
                "small-chance": "[certain]"
            },
            conjunction: {
                "and-or": "[and|or|and/or]",
                conditional: "[if|when|whenever|provided that|in case]",
                conclusion: "[as|because|and|but|so]"
            },
            preposition: "[before|below|for|from|inside|next to|opposite of|outside|over|to]",
            determiner: "[all|prepended|all prepended|post-prepended|catalogued|exported|pre-exported|cherry-picked|pre-initialized|the|the most recent]",
            subject: "[the user|the {command-name} command]",
            "command-name-raw": "git-{verb.common}-{noun.git}",
            "command-name": "<code>{command-name-raw}</code>",
            "command-option-raw": "--[{verb.common}-|]{verb.common}-{noun.git}",
            "command-option": "<code>{command-option-raw}</code>",
            "git-path-raw": "{noun.git|plural}/{noun.git|plural}/",
            "git-path": "<code>{git-path-raw}</code>",
            "multiple-nouns": "{determiner} {verb.git|tense.past} {noun.git|plural}",
            "located-noun": "[{noun.location} |]{noun.git}",
            "constant-noun-prefix": "[new|old|this|other|remote|local]",
            "constant-noun-constant": "{verb.common}_[{constant-noun-prefix}_|]{noun.git}",
            "constant-noun": [ "<i>&lt;[{constant-noun-prefix}|{verb.common}-]{noun.git}&gt;</i>", "<code>{constant-noun-constant|constantify}</code>" ],
            condition: [ "{conjunction.conditional} {constant-noun} is [not |]{verb.git|tense.past}", "{conjunction.conditional} {command-name} {verb.git|tense.present} {noun.git|prepend-an}" ],
            conclusion: [ "{conjunction.conclusion} {statement}" ],
            statement: [ "{constant-noun} is {verb.git|tense.past} to {verb.git} the {noun.git} of {determiner} {noun.git|plural} {preposition} the {noun.git}", "{command-name} {command-option} {verb.synonym.will} {verb.synonym.perform} {adjective.git-action|prepend-an} {command-name} before [{verb.git|tense.present-participle} the {noun.git}|doing anything else]", "{multiple-nouns} are {verb.git|tense.past} to {constant-noun} by {command-name}", "the same set of {noun.git|plural} would [{adverb.synonym.sometimes} |]be {verb.git|tense.past} in {adjective.git-action|prepend-an} {noun.git}", "{multiple-nouns} that were {adverb.synonym.previously} {verb.git|tense.past} {preposition} the {adjective.git-action} {noun.git|plural} are {verb.git|tense.past} to {adjective.git-action|prepend-an} {noun.git}", "{verb.git|tense.past|prepend-an} {noun.synonym.failure} {verb.synonym.will} prevent {adjective.git-action} {verb.git|tense.present-participle} of {multiple-nouns}", "{subject} {verb.synonym.will} {verb.git} {determiner} {noun.git|plural} {conjunction.and-or} run {command-name} {command-option} instead", "to {verb.git} {adjective.git-action|prepend-an} {constant-noun} {conjunction.and-or} {verb.git} the working {noun.git|plural}, use the command {command-name} {command-option}", "the {noun.git} to be {verb.git|tense.past} can be {verb.synonym.supply|tense.past} in several ways", "the {command-option} {noun.synonym.option} can be used to {verb.git} {noun.git|prepend-an} for the {noun.git} that is {verb.git|tense.past} by {adjective.git-action|prepend-an} {noun.git}", "any {verb.git|tense.present-participle} of {noun.git|prepend-an} that {verb.git|tense.present} {noun.git|prepend-an} {adverb.synonym.immediately} after can be {verb.git|tense.past} with {command-name}", "after {verb.git|tense.present-participle} {noun.git|plural} to any {noun.git|plural}, the user can {verb.git} the {noun.git} of the {noun.git|plural}", "after {command-name|prepend-an} ({verb.git|tense.past} by {command-name}[ {conjunction.and-or} {command-name}|]) {verb.git|tense.present} {noun.git|prepend-an}, {adverb.synonym.cleanly} {verb.git|tense.past} {noun.git|plural} are {verb.git|tense.past} for {subject}, and {noun.git|plural} that were {verb.git|tense.past} during {verb.git|tense.present-participle} are left in {verb.git|tense.past|prepend-an} state", "{multiple-nouns} {verb.git|tense.past} by {noun.git|plural} in the {located-noun}, but that [{adverb.synonym.sometimes} |]are [not |]in {constant-noun}, are {verb.git|tense.past} in {adjective.git-action|prepend-an} {noun.git}", "{command-name} takes {noun.synonym.option|plural} {adjective.synonym.relevant} to the {command-name} {noun.synonym.command} to {verb.synonym.verify} what is {verb.git|tense.past} and how" ],
            "command-action": "{$command-verb verb.common} {determiner} {noun.location} {$command-noun noun.git|noun.plural} {preposition} {determiner} {verb.git|tense.past} {located-noun|noun.plural}",
            "command-description": "{$command-verb verb.common|verb.tense.present} {determiner} {noun.location} {$command-noun noun.git|noun.plural} {preposition} {determiner} {verb.git|tense.past} {located-noun|noun.plural}, and {statement}.",
            "option-description": [ "{verb.git} the {noun.git|plural} of {determiner} {noun.git|plural} that are {verb.git|tense.past}", "{conjunction.conditional} this {noun.synonym.option} is {verb.synonym.supply|tense.past}, the {noun.git} prefixes {git-path} {conjunction.and-or} {git-path}", "the {noun.git} {verb.synonym.will} [not |]be {verb.common|tense.past} by {verb.git|tense.past|prepend-an} {noun.git}", "use {noun.git} to {verb.git} {git-path} to {verb.git|tense.past|prepend-an} {noun.git}", "with[out|] this {noun.synonym.option}, {command-name} {command-option} {verb.git|tense.present} {noun.git|plural} that {verb.git} the {verb.synonym.supply|tense.past} {noun.git|plural}" ]
        });
    }
    "object" == typeof module && module.exports ? module.exports = init : "function" == typeof define && define.amd ? define(function() {
        return init;
    }) : init(global.Baba);
}(this, "undefined" != typeof module && module, "undefined" != typeof define && define), 
function(global, pool, math, width, chunks, digits, module, define, rngname) {
    function ARC4(key) {
        var t, keylen = key.length, me = this, i = 0, j = me.i = me.j = 0, s = me.S = [];
        for (keylen || (key = [ keylen++ ]); i < width; ) s[i] = i++;
        for (i = 0; i < width; i++) s[i] = s[j = mask & j + key[i % keylen] + (t = s[i])], 
        s[j] = t;
        (me.g = function(count) {
            for (var t, r = 0, i = me.i, j = me.j, s = me.S; count--; ) t = s[i = mask & i + 1], 
            r = r * width + s[mask & (s[i] = s[j = mask & j + t]) + (s[j] = t)];
            return me.i = i, me.j = j, r;
        })(width);
    }
    function flatten(obj, depth) {
        var prop, result = [], typ = typeof obj;
        if (depth && "object" == typ) for (prop in obj) try {
            result.push(flatten(obj[prop], depth - 1));
        } catch (e) {}
        return result.length ? result : "string" == typ ? obj : obj + "\0";
    }
    function mixkey(seed, key) {
        for (var smear, stringseed = seed + "", j = 0; j < stringseed.length; ) key[mask & j] = mask & (smear ^= 19 * key[mask & j]) + stringseed.charCodeAt(j++);
        return tostring(key);
    }
    function autoseed(seed) {
        try {
            return global.crypto.getRandomValues(seed = new Uint8Array(width)), tostring(seed);
        } catch (e) {
            return [ +new Date(), global, (seed = global.navigator) && seed.plugins, global.screen, tostring(pool) ];
        }
    }
    function tostring(a) {
        return String.fromCharCode.apply(0, a);
    }
    var startdenom = math.pow(width, 6), significance = math.pow(2, 52), overflow = 2 * significance, mask = width - 1, impl = math.seedrandom = function(seed, use_entropy, callback) {
        var key = [], shortseed = mixkey(flatten(use_entropy ? [ seed, tostring(pool) ] : null == seed ? autoseed() : seed, 3), key), arc4 = new ARC4(key);
        return mixkey(tostring(arc4.S), pool), (callback || function(prng, seed, is_math_call) {
            return is_math_call ? (math.random = prng, seed) : prng;
        })(function() {
            for (var n = arc4.g(6), d = startdenom, x = 0; n < significance; ) n = (n + x) * width, 
            d *= width, x = arc4.g(1);
            for (;n >= overflow; ) n /= 2, d /= 2, x >>>= 1;
            return (n + x) / d;
        }, shortseed, this == math);
    };
    mixkey(math.random(), pool), module && module.exports ? module.exports = impl : define && define.amd && define(function() {
        return impl;
    });
}(this, [], Math, 256, 0, 0, "object" == typeof module && module, "function" == typeof define && define), 
function() {
    function randomSeed(seed) {
        if (seed) return Math.seedrandom(seed), seed;
        seed = Math.seedrandom();
        for (var hex = "", i = 0; i < seed.length; i++) hex += "" + seed.charCodeAt(i).toString(16);
        var seedSliced = hex.slice(0, seedLength);
        return Math.seedrandom(seedSliced), seedSliced;
    }
    function $(selector, el) {
        return el || (el = document), el.querySelector(selector);
    }
    function $$(selector, el) {
        return el || (el = document), el.querySelectorAll(selector);
    }
    function randomInt(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }
    function refresh() {
        var seed = randomSeed(urlSeed);
        urlSeed = null, $("#permalink").setAttribute("href", "#" + seed);
        var commandVerb = baba.render("verb.common"), commandNoun = baba.render("noun.git"), commandNameRaw = [ "git", commandVerb, commandNoun ].join("-");
        baba.setVariable("command-verb", commandVerb), baba.setVariable("command-noun", commandNoun);
        var i, commandName = "<code>" + commandNameRaw + "</code>", commandAction = baba.render("command-action"), commandDescription = baba.render("command-description"), commandNameContainers = $$(".command-name");
        for ($("header h1").innerHTML = commandName, i = 0; i < commandNameContainers.length; i += 1) commandNameContainers[i].innerHTML = commandName;
        document.title = commandNameRaw + " - git man page generator", $(".command-action").innerHTML = commandAction, 
        $(".command-description").innerHTML = commandName + " " + commandDescription;
        var args = [], rawArguments = [], argument = "";
        for (i = 0; i < randomInt(2, 4); i += 1) {
            if (Math.random() > .5) {
                for (var optarg = [], i = 0; i < randomInt(2, 4); i += 1) {
                    var a = baba.render("command-option-raw");
                    rawArguments.push(a), optarg.push(a);
                }
                argument = "[ " + optarg.join(" | ") + " ]";
            } else argument = baba.render("command-option-raw"), rawArguments.push(argument), 
            Math.random() > .5 && (argument = "[ " + argument + " ]");
            args.push(argument);
        }
        $(".command-arguments").innerHTML = " " + args.join(" ");
        for (var description = "", i = 0; i < randomInt(2, 4); i += 1) description += "<p>" + baba.render("paragraph") + "</p>";
        $("#description .contents").innerHTML = description;
        var argDesc = [];
        rawArguments.forEach(function(arg) {
            argDesc.push("<dt>" + arg + "<dd>" + baba.render("option-description"));
        }), $("#options").innerHTML = argDesc.join("");
        var seeAlso = [];
        for (i = 0; i < randomInt(2, 4); i += 1) seeAlso.push('<li><a href="#" class="refresh">' + baba.render("command-name") + "</a>");
        $("#see-also").innerHTML = seeAlso.join("");
        var refreshEls = $$(".refresh");
        for (i = 0; i < refreshEls.length; i += 1) refreshEls[i].addEventListener("click", refresh);
    }
    var baba = new Baba.Parser("git-manual"), seedLength = 32, urlSeed = (document.URL.split("#")[1] || "").slice(0, seedLength);
    refresh(), $("#refresh").addEventListener("click", refresh);
}();