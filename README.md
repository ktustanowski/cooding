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
I love to cook but this whole process is so annoying due to this limitations. I was thinkig for a long time on how to improve this. And I came up with a very simple solution. It's not ideal - but works far better, at least for me, than the regular ones.

## Make your own recipe
I created simple format of creating recipies. In fact it's very similar to the the regular way of writing recipies. There is only a small twist that makes things interesting.
Let's consider the `Pour milk into the pot` example. What could make this more self-contained? Quantity. So let's add it:
`Pour 2 glasses of milk into the pot`. It's better - I know how much milk I need to pour. But this is not how the regular recipies work unfortunatelly. So I need to create my own recipies from scratch based on the exisiting ones - just to make it more convenient. But then I have to track the ingredients etc. so, long story short, I turn this step into:
`Pour [2 glasses of milk] into the {pot}` [] marks ingredient needed to make the meal, {} marks dependencies like pot, frying pan, blender etc. (there is also <> marker which marks that this step should take some time i.e. boiling eggs). So basically this is natural language with some markers. Downside is that it's more work - someone has to write steps for the recipe. The twist is that only this is needed because ingredients and dependencies lists will be generated automatically from the recipe. If you change something the change will be reflected automatically. 
Note: ingredients are only something needed to be acquired before cooking. So if during course of action you get yolk from the egg which is needed later you don't mark it as ingredient. Only egg is marked.
If you want to know more and to try it out please check `MakeRecipe` playground in the cooding repository.

I decided that since I have this idea I can also check out some cool solutions and technologies I wanted to dive deeper but never had time to do so. So there you have it - alpha of my cooking-process-centric application. A lot of stuff is missing, not everything is great - yet. But I will work on the matter and one of the things I will start with is more unit test coverage. I just wanted to ship this asap. So I can use it. I decided that on launch playgrounds & snapshot tests are good enough. Since I'm only mocking internet connection and using real view models during snapshot testing, pretty big part of the application is already tested by this tests. But nonetheless unit tests are coming.

# Setup
Go to the cooding folder and do:
```
carthage bootstrap --platform iOS
cd Core
carthage bootstrap --platform iOS
```

Check the MakeRecipe playground to create your own recipies.

