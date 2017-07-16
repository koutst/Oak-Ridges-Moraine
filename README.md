# Oak-Ridges Moraine

Oak Ridges Moraine is a lightweight Object-Relational Mapping framework for Ruby, inspired by ActiveRecord.

## Demo

Running demo.rb sets up a Dog, Human and House model. A house has many humans, humans have many dogs. Dogs belong to a human, humans belong to a house.

### Instructions
1. Clone or download directory zip.
2. In the root directory run "load 'dogs.rb'".
3. Use the commands described below to mess around with the data.

### Querying methods
* `::all`
Returns an array of objects from a specific table.
* `::find(id)`
Returns an object with specified id. If id is not found, returns nil.
* `::where(params)`
Returns an array of objects that match the params.
