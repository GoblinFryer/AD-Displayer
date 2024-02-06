# **AD-Displayer**

AD-Displayer is a simple interface that as the vocation to centralized AD's informations to simplify data consultation. [^1] [^2]

![addisplayer](https://github.com/GoblinFryer/AD-Displayer/assets/158450292/ef7c4a3e-b503-42dd-b719-40e775ab951f)

## Features

- [X] Display AD user or computer groups
- [X] Display AD basic informations for user or computer
- [X] Compare AD groups from user or computers
- [ ] Search for a specific AD group linked or not to a user or a computer
- [ ] Customizable search

## **1. How To Launch**

To install AD-Displayer just double click on the .exe file. As simple as that.

## **2. How To Use**

Each button have a specific interaction with the textboxe. Let see how each button work.

| 1. **INFOS Button** |
:---------------------:

- The first textbox is used for user ID, as follow: **Alias** or **Firstname Lastname** (order is important)
- The second text is used for PC ID, as follow: **AD computer's name**

Then click on INFOS button and the result should be displayed in the third textbox (the big one).

| 2. **AD Groups Button** |
:-------------------------:

Here, only the first textbox is used. Simply type the computer name or user ID (*alias* or *firstname lastname*) and then press AD groups.

| 3. **Compare Button** |
:-----------------------:

For this one, the two textboxes are used and it will compare the first entry (typed into 1.) to the second entry (typed into 2.) and then it will compare AD groups that the first entry have that the second one do not have (order is important here) and will display the result.

That's it ! Pretty simple.

[^1]: It tries to :)
[^2]: the application might not work properly on your environment do not hesitate to modify the source code
