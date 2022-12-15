import SwiftUI
import UniformTypeIdentifiers

let testType = UTType.text

struct DropTest: DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        print(info)
        for item in info.itemProviders(for: [testType]) {
            print("Item: \(item.debugDescription) \(type(of: item))")
            item.loadItem(forTypeIdentifier: testType.identifier) { obj, err in
                print("loadItem")
                print(obj)
                print(err)
            }
            _ = item.loadObject(ofClass: String.self) { obj, error in
                print("\(type(of: obj))")
                guard error == nil else { return print("Failed to load our dragged item. \(error.debugDescription)") }
                print("drop item: \(obj.debugDescription)")
            }
        }
        print("Something received")
        return true
    }
}

struct ContentView: View {
    @State var source : [String] = ["A", "B", "C"]
    @State var dest : [String] = ["D","E","F"]
    var body: some View {
        HStack {
            List {
                ForEach(source, id: \.self) { element in
                    Text(element)
                        .onDrag { NSItemProvider(object: element as NSString) }
                }
            }
            List {
                ForEach(dest, id: \.self) { element in
                    Text(element)
                }
                .onDrop(of: [testType.identifier], delegate: DropTest())
            }

        }
        .padding()
    }
}
