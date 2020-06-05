# Challenge #3
 
We have a nested object, we would like a function that you pass in the object and a key and get back the value. How this is implemented is up to you.
 
Example Inputs
```
object = {'a':{'b':{'c':'d'}}}
key = a/b/c
object = {'x':{'y':{'z':'a'}}}
key = x/y/z
value = a
```
 
Hints
We would like to see some tests. A quick read to help you along the way
We would expect it in any other language apart from elixir.
Again thank you for spending your precious time on our challenge.

# Approach

First thoughts are to create a recursive function that can deal take the keys for nested dictionaries and append them, such that an key input for deepest value can be provided as suggested above (a/b/c).

Python is the chosen language for this task,

1) create a bunch of test objects to develop against;
2) look at similar patterns for flattening nested dictionaries with a recursive function;
3) create a filter function for user to pass in desired key;
4) combine functions;
5) leverage unittest module with ddt module for easy data-driven testing of arbitrary objects.
6) write tests that prove solution works.
7) if I had more time, I'd look into some more elaborate try/catch logic and look at a way of dealing with embedded lists.

# How do I use these files?

## venv usage
For ease of sharing any potential requirements / dependencies, I created a virtual env, using:
```
python3 -m venv .venv
source .venv/bin/activate
```
There is only one non-standard library module in use here, which can be installed in your venv by running:
```
pip install -r requirements.txt
OR
pip install ddt
```

## The rest

objects.py: contains some test objects(dictionaries) used to help validate output during development/testing. You can add arbitrary objects(dictionaries) to this file to test further cases.

flatten.py: contains the logic, as required for challenge 3. The file is pre-configured to output the values for pre-defined keys. Feel free to change these. Note that invalid keys return 'None'.

tests.py: contains tests using unittest and ddt. 

You can invoke both flatten.py and tests.py by simply running:
```
python3 flatten.py
OR
python3 tests.py
```

