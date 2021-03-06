
# Michael Williams Color Configuration File
#

### Color Code Info
# 8/16 ANSI Color Code Chart 
# _____________|_Foreground_|_Background_|
# Default      |     39     |     49     |
# Black        |     30     |     40     |
# Red          |     31     |     41     |
# Green        |     32     |     42     |
# Yellow       |     33     |     43     |
# Blue         |     34     |     44     |
# Magenta      |     35     |     45     |
# Cyan         |     36     |     46     |
# Grey         |     37     |     47     |
# Dark Grey    |     90     |    100     |
# Light Red    |     91     |    101     |
# Light Green  |     92     |    102     |
# Light Yellow |     93     |    103     |
# Light Blue   |     94     |    104     |
# Light Purple |     95     |    105     |
# Light Cyan   |     96     |    106     |
# White________|_____97_____|____107_____|
#
# 88/256 Color Code Chart
# http://upload.wikimedia.org/wikipedia/en/1/15/Xterm_256color_chart.svg

# Formatting - Applies to Both 8/16 and 88/256 Colors
# _____________|__Set__|_Reset_|
# Reset All    |   NA  |    0  |
# Bold/Bright  |    1  |   21  |
# Dim          |    2  |   22  |
# Underlined   |    4  |   24  |
# Blink        |    5  |   25  |
# Reverse      |    7  |   27  |
# Hidden_______|____8__|___28__|
#
# Color Code Format
# "<Esc>[FormatCodem"
# In Bash, the <Esc> character can be obtained with the following
#  \e
#  \033
#  \x1B 
# Ex: "\e[31mHello" would print "Hello" in Red
# Can combine codes by seperating them with a ';'
# Ex: "\e[1;31mHello" would print "Hello" in Bold Red
# Ex: "\e[1;4;31mHello" would print "Hello" in Bold, Underlined Red

# Test Functions
#  These functions print example text for the colors and formatting
#  Show16ColorChart()
#  Show256ColorChart()
#  ShowColorFormatting()
#

source "$DOTFILE_DIR/colortests.sh"

### Begin Actual Configuration

# Use 256 colors if available
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
   export TERM='xterm-256color'
fi

# Print the number of colors available to the shell
NUM_COLORS=$(tput colors)
echo "${NUM_COLORS} colors"

# Enable colors
export CLICOLOR=1

#source "$DOTFILE_DIR/.lscolors"
source "$DOTFILE_DIR/easylscolors.sh"


# LSCOLORS is used by OSX and BSD
#export LSCOLORS=ExFxBxDxCxegedabagacad
# LS_COLORS is used by most other variants
#export LS_COLORS='di=1;34;40:ln=1;35;40:so=1;31;40:pi=1;33;40:ex=1;32;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
#if [[ "$OSTYPE" == "darwin"* ]]; then
#   export LSCOLORS=FxExBxDxCxegedabagacad
#elif [[ "$OSTYPE" == "linux-gnu" ]]; then
#   export LS_COLORS='di=1;95:ln=1;35:so=1;31:pi=1;33:ex=1;32:bd=34:cd=34:su=0:sg=0:tw=0:ow=0:'
#fi

# Prompt Coloring
export PROMPT_COMMAND=__prompt_command

function __prompt_command()
{
   local EXIT="$?"   #Needs to be first
   PS1=""

   local Reset='\[\e[0m\]'    # Reset all attributes
   local Default='\[\e[39m\]'  # Default foreground colors

   local NumColors=$(tput colors)
   if [ $NumColors -ge 256 ]; then
      #256 Default Colors
      #Green   = 150
      #Orange  = 216
      #Grey    = 242
      #Blue    = 110
      #Red     = 52
      
      local Green='\[\e[38;5;150m\]'
      local Orange='\[\e[38;5;216m\]'
      local Grey='\[\e[38;5;242m\]'
      local Blue='\[\e[38;5;110m\]'
      local Red='\[\e[38;5;204m\]'
 
   elif [ $NumColors -ge 8 ]; then
      #16/8 Default Colors
      #Green   = 32
      #Orange  = 33
      #Grey    = 90
      #Blue    = 96
      #Red     = 91

      local Green='\[\e[32m\]'
      local Orange='\[\e[33m\]'
      local Grey='\[\e[90m\]'
      local Blue='\[\e[96m\]'
      local Red='\[\e[91m\]'
   
   else
      #If for whatever reason we don't have colors don't bother coloring
      local Green=''
      local Orange=''
      local Grey=''
      local Blue=''
      local Red=''
   fi

   local ExitCodeC=${Grey}
   if [ $EXIT != 0 ]; then
      local ExitCodeC=${Red}
   fi

   PS1+="${Green}\u${ExitCodeC}@${Orange}\h"   # user@host
   PS1="${ExitCodeC}[${PS1}${ExitCodeC}: ${Blue}\\w${ExitCodeC}]"  # [user@host: ~]

   if [ $EXIT != 0 ]; then
      PS1+="${ExitCodeC}(${Default}${EXIT}${ExitCodeC})"
   fi
   
   PS1+="${Blue}\$ ${Reset}"  # [user@host: ~]$ 
}
