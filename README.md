# PageTab

Page tab

![111](./resource/demo.gif)

### Usage

```swift
PageTabView {
	Text("red").foregroundColor(.red)
	Text("green").foregroundColor(.green)
} content: { model in
	VStack {
		Button("red") {
			model.page = 1
		}
	}

	VStack {
		Button("green") {
			model.page = 0
		}
	}
}
.accentColor(.black)
```
