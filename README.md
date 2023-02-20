# PageTab

Page Tab

![111](./resource/demo.gif)

### Usage

```swift
PageTabView {    
    List {
        Text("Page 1")

        Button("Green") {
            pageModel.scrollTo(page: 1)
        }
        .accentColor(.blue)
    }
    .edgesIgnoringSafeArea(.bottom)
    .pageTitleView {
        Text("Page1").foregroundColor(.red)
    }

    VStack {
        Text("Page 1")
        Button("Red") {
            pageModel.scrollTo(page: 0)
        }
        .accentColor(.blue)
    }
    .pageTitleView {
        Text("Page2").foregroundColor(.green)
    }
}
.environmentObject(pageModel)
.accentColor(.purple)
```
