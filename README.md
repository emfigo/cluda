[![Build Status](https://api.travis-ci.org/emfigo/cluda.png)](https://api.travis-ci.org/emfigo/cluda)

CluDA
=====
The aim of CLuDA is to group the data points into clusters such that similar items are lumped together in the same cluster, using different classification supervised or unsupervised learning techniques.

#Installation

```ruby
gem install cluda
```

#Usage

In the current version it only exist Kmeans as a clustering algorithm, but in future updates the idea is to have several options to choose for clustering.

CluDA is prepared to use any clustering algorithm that is implemented within it and call the method 'classify' to get the output. Classify is has 2 mandatory parameters and 2 optionals:

```ruby
Cluda::X.classify( list, k: K, distance_method: DISTANCE, max_iterations: MAX )
```

Mandatory
---------
 list             =>  List of points that you wish to classify

Optional
--------
 k                => Number of clusters
 centroids        => If you wish to work with specific initial centroids
 distance_method  => Should be a string in lowercase and can be: 
                         'euclidean' (default)
                         'manhattan'
                         'chebyshev'
 be_smart         => In case is necessary CluDA will create new centroids to the set passed as parameter 
 max_iterations   => Natural > 0 for local minimums. 50 (default)

The output will always be an hash with the centroids and the points clustered to the corresponding centroid.

##KMeans

Anytime that you want to use it, simply follow Cluda by the 'Kmeans' class. Showed in the example above:

```ruby
  require 'cluda'
  ...
  points = [ { x: 1, y: 1}, { x: 2, y: 1}, { x: 1, y: 2}, { x: 2, y: 2}, { x: 4, y: 6}, { x: 5, y: 7}, { x: 5, y: 6}, { x: 5, y: 5}, { x: 6, y: 6}, { x: 6, y: 5}]
  Cluda::Kmeans.classify( points, k: 1)
  ...
```

Output

```ruby
=> {{:x=>4, :y=>5}=>
  [{:x=>1, :y=>1},
   {:x=>2, :y=>1},
   {:x=>1, :y=>2},
   {:x=>2, :y=>2},
   {:x=>4, :y=>6},
   {:x=>5, :y=>7},
   {:x=>5, :y=>6},
   {:x=>5, :y=>5},
   {:x=>6, :y=>6},
   {:x=>6, :y=>5}]}
```

Other examples followed by the outputs:

```ruby
  Cluda::Kmeans.classify( points, k: 2, distance_method: 'euclidean' )
```

Output

```
=> {{:x=>1, :y=>1}=>
  [{:x=>1, :y=>1}, {:x=>2, :y=>1}, {:x=>1, :y=>2}, {:x=>2, :y=>2}],
   {:x=>5, :y=>6}=>
  [{:x=>4, :y=>6},
   {:x=>5, :y=>7},
   {:x=>5, :y=>6},
   {:x=>5, :y=>5},
   {:x=>6, :y=>6},
   {:x=>6, :y=>5}]}
```
-------------------

```ruby
  Cluda::Kmeans.classify( points, k: 2, distance_method: 'manhattan' )
```

Output

```
=> {{:x=>5, :y=>6}=>
  [{:x=>4, :y=>6},
   {:x=>5, :y=>7},
   {:x=>5, :y=>6},
   {:x=>5, :y=>5},
   {:x=>6, :y=>6},
   {:x=>6, :y=>5}],
   {:x=>1, :y=>1}=>
  [{:x=>1, :y=>1}, {:x=>2, :y=>1}, {:x=>1, :y=>2}, {:x=>2, :y=>2}]}
```

--------------------

```ruby
  Cluda::Kmeans.classify( points, k: 2, distance_method: 'chebyshev' )
```

Output

```
=> {{:x=>1, :y=>1}=>
  [{:x=>1, :y=>1}, {:x=>2, :y=>1}, {:x=>1, :y=>2}, {:x=>2, :y=>2}],
   {:x=>5, :y=>6}=>
  [{:x=>4, :y=>6},
   {:x=>5, :y=>7},
   {:x=>5, :y=>6},
   {:x=>5, :y=>5},
   {:x=>6, :y=>6},
   {:x=>6, :y=>5}]}
```

