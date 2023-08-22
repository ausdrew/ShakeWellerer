## ShakeWellerer

ShakeWellerer is an Alfred Workflow that allows you to setup groups of snippets with an associated trigger. Each time a snippet group is triggered, a random snippet from that group is pasted into the active application.

It can be used to add some variation to your canned ticket responses, or to quickly paste some random variation of commonly used text.

Inspired by [@yamiacat](https://github.com/yamiacat)'s ShakeWeller, this edition focuses on flexibility, ease of use and making use of Alfred's Workflow configuration.

### Features
- Supports Emoji ✨!
- Uses the Mac OS clipboard in compliance with [NSPasteboard.org](http://nspasteboard.org/) to preserve clipboard history.
- Supports customization of newlines and spacing.
- Based on Swift, so it's fast and lightweight*.

<sub>*Kinda, probably doing a bit much for the task at hand.</sub>

### Installation

Download [ShakeWellerer.alfredworkflow](https://github.com/ausdrew/ShakeWellerer/raw/main/ShakeWellerer.alfredworkflow) and open it to install.

### Configuration
Snippets can be defined in the Alfred Workflow Configuration - click the 'Configure Workflow...' button.

<img width="437" alt="configure" src="https://github.com/ausdrew/ShakeWellerer/assets/6315839/831f7dcd-6744-4553-8a8d-f835b8896b78">

##### Snippets are delimited by `--` (two hyphens).

Each snippet group can have its _Extra Lines_ set separately. This is the number of newlines that will be added after the snippet is pasted. This is useful for getting your cursor to the next line after your snippet to continue writing, but can be turned off. Newlines and spacing within snippets are kept so you can optionally just include them in your text.

<img src="https://drew.onl/images/ShakeWellerer/configuration.png" width="600px" /> 

Each snippet group can have a keyword assigned that is used to trigger that snippet group.

![keywords screenshot](https://drew.onl/images/ShakeWellerer/keywords.gif?)

### Adding more snippet groups (Advanced)

The script imports snippets that are defined in Alfred's workflow configuration via the use of environment variables.

Alfred has some documentation on how these work:

- [Using Variables in Workflows](https://www.alfredapp.com/help/workflows/advanced/variables/#environment)
- [Reading Environment Variables](https://www.alfredapp.com/help/kb/reading-environment-variables/)
- [Configuring your Workflow as a creator](https://www.alfredapp.com/help/workflows/workflow-configuration/)

Additional snippet groups can be added by adding more fields to the configuration builder and creating additional triggers.

1. Open the 'Prepare workflow configuration and variables' window from the $(x)$ button in the workflow window.
<img width="206" alt="Screenshot 2023-08-22 at 9 34 23 pm" src="https://github.com/ausdrew/ShakeWellerer/assets/6315839/afdbb562-37b6-4fde-bbfb-66c8199677c7">

2. On the 'Configuration Builder' tab add a new text area from the $+$ menu
- **Variable**: Used later to build your trigger for this snippet group, must be unique, take note of it. e.g. _SnippetGroup6_
- **Label**: User facing name where you can edit the snippet group. e.g. _Snippet Group 6_
- **Description**: User facing description for this snippet group.
- **Vertical Size**: Set to large to allow for more space when editing.
- **Default Value**: Optional default text for snippet group contents.
- **Trimming**: Untick this to prevent Alfred removing newlines and whitespace.
- **Validation**: Use your own judgement :)

_**Optional**_: Repeat the same steps with a text field to create an additional "Extra Lines" option as well. You can also re-use an existing Extra Lines variable from another snippet group when configuring your trigger, just note it down. If no Extra Lines variable is supplied the script will default to 2.

![Screen Recording 2023-08-22 at 9 37 35 pm mov](https://github.com/ausdrew/ShakeWellerer/assets/6315839/6440a3be-69b5-4fd0-a95a-ff52a8f31dda)

3. Configure your snippets as desired in the regular 'Configure workflow...' window now that there are additional fields.

4. Create a new Trigger & 'Arg & Vars' block in the workflow and drag to connect it all together
- The trigger will be the text or hotkey that generates this snippet block
- The 'Arg & Vars' block tells the script which configuration/snippet group to select from
  - **Selector**: This variable tells the script which snippet group to use, enter the Variable name you selected earlier as its value.
  - **ExtraLines**: This variable tells the script which Extra Lines value to use, enter the variable name for this field, or an existing one, or leave it blank for the default (2).

https://github.com/ausdrew/ShakeWellerer/assets/6315839/663eb8c5-9daa-4464-b3bc-fc1c4dc432f3

You should now have an additional snippet group to use and configure as needed!
