require 'tensor_stream'
tf = TensorStream
learning_rate = 0.01
training_epochs = 1000
display_step = 50

train_X = Array.new(100) {rand(100)  }
train_Y = train_X.map { |e|e*0.1 + 0.3  }
n_samples = train_X.size

X = tf.placeholder("float")
Y = tf.placeholder("float")

# Set model weights
W = tf.variable(rand, name: "weight")
b = tf.variable(rand, name: "bias")

# Construct a linear model
pred = X * W + b

# Mean squared error
cost = tf.reduce_sum(tf.pow(pred - Y, 2)) / ( 2 * n_samples)

optimizer = TensorStream::Train::GradientDescentOptimizer.new(learning_rate).minimize(cost)

# Initialize the variables (i.e. assign their default value)
init = tf.global_variables_initializer()

tf.session do |sess|
    start_time = Time.now
    sess.run(init)
    (0..training_epochs).each do |epoch|
      train_X.zip(train_Y).each do |x,y|
        sess.run(optimizer, feed_dict: {X => x, Y => y})
      end

      if (epoch+1) % display_step == 0
        c = sess.run(cost, feed_dict: { X => train_X, Y => train_Y })
        puts("Epoch:", '%04d' % (epoch+1), "cost=",  c, \
            "W=", sess.run(W), "b=", sess.run(b))
      end
    end

    puts("Optimization Finished!")
    training_cost = sess.run(cost, feed_dict: { X => train_X, Y => train_Y})
    puts("Training cost=", training_cost, "W=", sess.run(W), "b=", sess.run(b), '\n')
    puts("time elapsed ", Time.now.to_i - start_time.to_i)
end