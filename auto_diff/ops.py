from utils import broadcast
import numpy as np

# g is the upstream gradient (next layer's gradient)
# len(return_backward) == len(input_forward) - reverse mode AD


@broadcast
class Add:
    def forward(x, y):
        # z = x + y
        return np.add(x.value, y.value)

    def backward(g, x, y, z):
        # z = x + y
        # dz / dx = 1 => g_x = g
        # dz / dy = 1 => g_y = g
        return [g, g]


@broadcast
class Sub:
    def forward(x, y):
        # z = x - y
        return x.value - y.value

    def backward(g, x, y, z):
        # z = x - y
        # dz / dx = 1 => g_x = g
        # dz / dy = -1 => g_y = -g
        return [g, -g]


@broadcast
class Mul:
    def forward(x, y):
        # z = x * y
        return x.value * y.value

    def backward(g, x, y, z):
        # z = x * y
        # dz / dx = y => g_x = g * y
        # dz / dy = x => g_y = g * x
        g_x = g * y.value
        g_y = g * x.value

        return [g_x, g_y]


@broadcast
class Div:
    def forward(x, y):
        # z = x / y
        return x.value / y.value

    def backward(g, x, y, z):
        # z = x / y
        # dz / dx = 1 / y => g_x = g * (1 / y)
        # dz / dy = -x / y^2 => g_y = g * (-x / y^2)
        g_x = g * (1.0 / y.value)
        g_y = g * (-x.value / (y.value**2))

        return [g_x, g_y]


@broadcast
class Pow:
    def forward(x, y):
        # z = x ^ y
        return x.value**y.value

    def backward(g, x, y, z):
        # Note: We do not compute the 'y' grad.
        # z = x ^ y
        # dz / dx = y * x^(y-1) => g_x = g * y * x^(y-1)
        g_x = g * y.value * np.power(x.value, y.value - 1)
        g_y = np.array([[0]])

        return [g_x, g_y]


### --- Basic Activation Function Ops --- ###
class Sigmoid:
    def forward(x):
        # z = 1 / (1 + exp(-x))
        return 1.0 / (1.0 + np.exp(-x.value))

    def backward(g, x, z):
        # z = 1 / (1 + exp(-x))
        # dz / dx = z * (1 - z) => g_x = g * z * (1 - z)
        return [g * (z.value * (1.0 - z.value))]


class ReLU:
    def forward(x):
        # z = max(0, x)
        return np.maximum(x.value, 0)

    def backward(g, x, z):
        # z = max(0, x)
        # dz / dx = 1 if x > 0 else 0
        return [g * (x.value > 0)]


class Leaky_ReLU:
    def forward(x):
        # z = max(0.1 * x, x)
        return np.maximum(x.value, 0.1 * x.value)

    def backward(g, x, z):
        # z = max(0.1 * x, x)
        # dz / dx = 1 if x > 0 else 0.1
        return [g * np.where(x.value > 0, 1, 0.1)]


class TanH:
    def forward(x):
        # z = (exp(x) - exp(-x)) / (exp(x) + exp(-x))
        return (np.exp(x) - np.exp(-x)) / (np.exp(x) + np.exp(-x))

    def backward(g, x, z):
        # z = (exp(x) - exp(-x)) / (exp(x) + exp(-x))
        # dz / dx = 1 - z^2 => g_x = g * (1 - z^2)
        return [g * (1.0 - (z.value**2))]


### --- Primitive Matrix Operations --- ###
class Sum:
    def forward(x, **kwargs):
        # z = sum(x)
        return np.sum(x.value, **kwargs)

    def backward(g, x, z):
        # z = sum(x)
        # dz / dx = 1 => g_x = g
        return [np.broadcast_to(g, x.shape)]


class Dot:
    def forward(x, y):
        # z = x @ y
        return x.value.dot(y.value)

    def backward(g, x, y, z):
        # z = x @ y
        # dz / dx = y^T => g_x = g @ y^T
        # dz / dy = x^T => g_y = x^T @ g
        return [g.dot(y.value.T), x.value.T.dot(g)]


class Transpose:
    def forward(x):
        # z = x^T
        return x.value.T

    def backward(g, x, z):
        # z = x^T
        # dz / dx = 1 => g_x = g^T
        return [g.T]


class Reshape:
    def forward(x, *shape, **kwargs):
        # z = reshape(x, shape)
        return np.reshape(x.value, shape, **kwargs)

    def backward(g, x, z):
        # z = reshape(x, shape), reshapes grad back to x's shape
        # dz / dx = 1 => g_x = g
        return [g.reshape(x.shape)]


### --- Elem-Wise Ops --- ###


class Log:
    def forward(x):
        # z = log(x)
        return np.log(x.value)

    def backward(g, x, z):
        # z = log(x)
        return [g / x.value]


class Exp:
    def forward(x):
        # z = exp(x)
        return np.exp(x.value)

    def backward(g, x, z):
        # z = exp(x)
        return [g * z.value]


class Abs:
    def forward(x):
        # z = abs(x)
        return np.abs(x.value)

    def backward(g, x, z):
        # z = abs(x)
        # returns 0 if x == 0 else 1
        return [g * (z.value / np.where(x.value == 0, x.value, 1))]


class Max:
    def forward(x):
        # z = max(x)
        return np.max(x.value)

    def backward(g, x, z):
        # z = max(x)
        # dz / dx = 1 if x == z else 0
        return [g * (x.value == z.value) / np.sum(x.value == z.value)]
