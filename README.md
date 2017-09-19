![Baya](logo.png)

# Baya
A simple layout framework written in Swift.

## Features

- *Baya* encapsulates layout logic in structs.
- Build nested layouts without a nested view hierachy. 
- Write simple and readable layout code.
- It's extendable with your own layouts.
- Works without Interface Builder or Auto Layout.


## Installation

#### Carthage

Add the following to your `Cartfile`
```
github "getwagit/Baya" ~> 1.0.0
```


## Usage
A basic layout with *Baya* looks like this:

```swift
...
var layout: BayaLayoutable?

override func loadView() {
  ...
  // Add views directly as sub views of the ViewControlles's root view.
  view.addSubView(profilePicture)
  ...

  // Create your layout. In this case just a simple linear layout.
  layout = [profilePicture, userName, friendCount].layoutLinearly(orientation: .horizontal)
}
```
Apply the layout by calling `startLayout(with:)`. A good place to do this in a `ViewController` is `viewWillLayoutSubviews()`.
```swift
override func viewWillLayoutSubviews() {
  // Apply the layout.
  layout?.startLayout(with: view.bounds)
}
```
Another example for a simple layout:
```swift
let buttonRowLayout = [button1, button2, button3]
  .layoutLinearly(
    orientation: .horizontal,
    spacing: 20)

let pictureLayout = profilePicture
  .layoutWithFixedSize(
    width: 100,
    height: 100)
  .layoutGravitating(to: .center)

let usernameLayout = nameLabel
  .layoutGravitating(to: .center)

layout = [pictureLayout, usernameLayout, buttonRowLayout]
  .layoutLinearly(orientation: .vertical)
```

## Docs
Visit the [wiki](https://github.com/getwagit/Baya/wiki) for more information on the default layouts and how to use them.

## Contributing
Contributions are welcome! Please use the branch `develop` as base/target. If you modifiy the `project.pbxproj` file, use [xUnique](https://github.com/truebit/xUnique): `$ xunique -u -s -c Baya.xcodeproj`

## License 
Baya is available under the MIT license.


