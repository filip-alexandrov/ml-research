from tensor import Tensor


def test_grad():
    a = Tensor(2)
    b = Tensor(2)
    c = Tensor(4)

    z = c * (a + b)
    print(z)

    z.backward()
    print(z._children)


if __name__ == "__main__":
    test_grad()
