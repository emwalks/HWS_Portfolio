# Portfolio

[HWS Portfolio App](https://www.hackingwithswift.com/plus/ultimate-portfolio-app)

## Topics Covered

Xcode 14.2 iOS 16

- CoreData
- CloudKit

## Core Data

Once we’ve configured our Core Data container, we can load it by calling loadPersistentStores(). This will load the actual underlying database on disk, or create it if it doesn’t already exist, but if that fails somehow we don’t really have any choice but to bail out – something is very seriously wrong!

Because we defined entities called `Resource` and `Tag`, Xcode will automatically synthesize classes called Issue and Tag for us to use, with properties matching all the attributes we defined. Even better, when you create instances of these classes using our Core Data stack, they can be loaded and saved almost automatically – it’s a massive time saver.

## CloudKit

This is responsible for loading and managing local data using Core Data, but also synchronizing that data with iCloud so that all a user’s devices get to share the same data for our app.

## Why not use a singleton data model?

This is a common place where folks want to use singletons – a simple design pattern that creates one instance of a type when the application first launches, and restricts the whole rest of the code to use that shared instance.

Singletons are used extensively on Apple’s platforms, and very often they make sense – there’s a UIDevice singleton because it’s the device you’re using right now, there’s a UIApplication singleton because it’s the app that’s running right now, and so on.

But although singletons are common and often make sense, they have a massive drawback in that they are much harder to test – if everyone shares the same data storage, it’s harder to ensure you have a clean slate every time a test runs.
