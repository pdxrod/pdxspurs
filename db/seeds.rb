fruits = ['Mango', 'Pineapple', 'Passion fruit']
fruits.each{|fruit| Fruit.create(name: fruit, classification: "FRUIT", description: "I am a delicious #{fruit}.")}
cars = {'Ferrari': 'fast', 'Ford Focus': 'slow'}
cars.each{|fruit, speed| Fruit.create(name: fruit, classification: "car", description: "I am a #{speed} car.")}
