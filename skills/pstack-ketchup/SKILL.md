---
name: pstack-ketchup
description: Catch the user up on what changed in this chat since their last message, in a few plain sentences and small visuals, with just enough context on each action item to make the call. Use for /pstack-ketchup, or after an unattended run.
disable-model-invocation: true
---

# Ketchup

Catch the user up on what changed in this chat since the last message they wrote, and help them understand each change, not only where it stands. Notifications and subagent results are not their messages. Assume the user remembers their last message and nothing after it.

Use the voice of **bro**: plain words, short sentences, no jargon, like one person catching up another. Say what changed for the user, not how you did it. Say "the tests pass", not "CI is green". Leave out hashes, file paths, commands, build numbers, and test counts unless the user needs one to act. Call each PR, branch, or agent by a name the user would know.

## Gather what changed

Keep this turn read-only. Do not change code, start an app or a job, or post anything. Collect your own work since that message, reports from subagents, and messages from anyone else. Check the current state of each PR, CI run, or agent this chat touched. Check each number against the facts it comes from, and say so when you correct one.

An action item is a decision or step only the user can take: a product choice, an approval, an irreversible action, or access you lack. Include any still waiting on the user, even one raised before their last message. Work you can still do yourself is not an action item. Never make up a call to fill the reply.

## Write the reply

Keep the whole reply well under 150 words, not counting visuals.

1. Open with one sentence that says how many things need the user, or that nothing does. If nothing happened and nothing waits on the user, say so and stop.
2. Show what happened, pictures first. Screenshots the work produced, then any diagram that explains a change (a mermaid diagram for how things connect). Never draw a status list or boxes with nothing connecting them. Keep each visual small: at most six boxes, at most eight words in each. A markdown table is not a visual.
3. One short bullet per thing the user asked for: what came of it, and whether it is done, still running, failed, or not checked. Write each line the way you would say it out loud ("Search was slow from a missing index"). Never mark something done that still waits on the user.
4. At most three short lines that change what the user knows or must do. Then one line naming work left that you can do yourself.
5. Action items as plain bullets. Give each two lines: the decision with your recommendation and why, then what happens if the user does not answer. Write "unknown" for a part you do not know.

Never give a fact twice. Never invent a number. Never draw a screen you did not capture. Link only artifacts that exist.
