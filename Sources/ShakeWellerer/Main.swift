import ShakeWellererCore

let shake = ShakeWellererCore()

do {
    try shake.run()
} catch {
    print("Whoops! An error occurred: \(error)")
}