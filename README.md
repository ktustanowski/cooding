<WORK IN PROGRESS>
  
# Cooding
Cooking and coding has a lot more in common than you could think!

# Context
Cooking is one of my hobbies. I have recipies on paper pages, in books and on the internet. I was testing various of cooking apps and realised that, overall, everything I was able to find on the subject is focused on searching recipies. Not the actual cooking process. 
So what cooking looks like using regular recipies:
- check ingredients list and go to store and buy missing stuff
- start cooking
- read something like "Pour milk into the pot". At this stage I never remeber exact quantity of the ingredient I should use. So I go back to the ingredients list to check it out.
- and again, and again, and again...

But this is this "easy" only when I print recipies (which is not very environment friendly).
When I'm using the computer or phone they constantly go to power save mode. So I have to wake the device, scroll the application to ingredients. If I have clean hands. And clean hands and cooking does not go hand in hand. So I have to wash hands, use towel, then go to device etc.
The pattern is emerging. 
I love to cook but this whole process is so annoying due to this limitations. I was thinkig for a long time on how to improve this. And I came up with a very simple solution. It's not ideal - but works far better, at least for me, than the regular ones. It looks like this:
![Application screens](https://raw.githubusercontent.com/ktustanowski/cooding/master/Resources/screens.png)

## Make your own recipe
I created simple format of creating recipies. In fact it's very similar to the the regular way of writing recipies. There is only a small twist that makes things interesting.
Let's consider the `Pour milk into the pot` example. What could make this more self-contained? Quantity. So let's add it:
`Pour 2 glasses of milk into the pot`. It's better - I know how much milk I need to pour. But this is not how the regular recipies work unfortunatelly. So I need to create my own from scratch based on the exisiting ones - just to make it more convenient. But then I have to track the ingredients etc. Long story short, I turn this step into:
`Pour [2 glasses of milk] into the {pot}` 
[] marks ingredient needed to make the meal, 
{} marks dependencies like pot, frying pan, blender etc. 
(there is also <> marker which marks that this step should take some time i.e. boiling eggs). 
Basically this is natural language with some markers. Downside is that it's more work - someone has to write steps for the recipe. The twist is that only this is needed because ingredients and dependencies lists will be generated automatically from the recipe. If you change something the change will be reflected automatically. 
Note: ingredients are only something needed to be acquired before cooking. So if during course of action you get yolk from the egg which is needed later you don't mark it as ingredient. Only egg is marked.
If you want to know more and to try it out please check `MakeRecipe` playground in the cooding repository. It's configured in a way to show parsed recipe data in the console but also in the application (live view feature).
![Application screens](https://raw.githubusercontent.com/ktustanowski/cooding/master/Resources/making_a_recipe.png)
It's wysiwyg and in the end you get a json ready to be used. Wait? A json? Let me explain.

## Add the recipe to the repository
Since cooking is similar to coding a bit. We are using algorithms etc. I thought that it would be nice to have recipies in repositories. Like code:
- this is example top-level file that holds all recipies in the repository. I don't force any file naming conventions. You just have to have a properly structured json file and provide URL to it in the application in **My** tab. When you do it application will load your recipies.
https://github.com/ktustanowski/cooding/blob/master/Recipes/recipes_list.json
```
{
    "recipes": [ 
        {
            "name": "Pancakes",
            "sourceURL": "https://raw.githubusercontent.com/ktustanowski/recipes/master/pancakes.json",
            "imageURL": "https://cdn.pixabay.com/photo/2016/10/27/22/07/pancake-1776646_1280.jpg"
        }
    ]
}
```
- this is example of a recipe. Exactly this can be easily created using MakeRecipie playground.
https://raw.githubusercontent.com/ktustanowski/recipes/master/pancakes.json
```
{
    "name": "Pancakes",
    "authorName": "Kamil Tustanowski",
    "authorURL": "https://www.linkedin.com/in/kamil-tustanowski-41498555",
    "imagesURL": ["https://cdn.pixabay.com/photo/2016/10/27/22/07/pancake-1776646_1280.jpg"],
    "rawAlgorithm": ":: version 0.1\nPrepare {blender}\nAdd [1.25 glass of buttermilk] to the {blender}\nAdd [0.25 glass of powdered sugar] to the {blender}\nAdd [1.0 heaping teaspoon of baking powder] to the {blender}\nAdd [1.0 teaspoon of baking soda] to the {blender}\nAdd [1.0 pinch of salt] to the {blender}\nBlend everything in a {blender} to a smooth mass with the consistency of thick cream\nPreheat the {frying pan}\nFry pancakes on both sides in a {frying pan} over medium heat",
    "time": 1800,
    "people": 3,
    "difficulty": "easy"
}
```
When you have this is place you are ready to do some actual cooking.
Please consider sharing your recipie with everyone by creating a PR with name, source URL and image URL of your recipie to the recipe list. Only this is needed and the actual recipe should remain in your repository so if you change anything it will be already up to date.

# Work in progress
I decided that since I have this idea I can also check out some cool solutions and technologies I wanted to dive deeper but never had time to do so. So there you have it - alpha of my cooking-process-centric application. A lot of stuff is missing, not everything is great - yet. But I will work on the matter and one of the things I will start with is more unit test coverage. I just wanted to ship this asap. So I can use it. I decided that on launch playgrounds & snapshot tests are good enough. Since I'm only mocking internet connection and using real view models during snapshot testing, pretty big part of the application is already tested by this tests. But nonetheless unit tests are coming. 
The overall polish, animations etc. is also coming.

# Project setup
After cloning the project go to the cooding folder and do:
```
carthage bootstrap --platform iOS
cd Core
carthage bootstrap --platform iOS
```
