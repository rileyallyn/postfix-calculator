stack = []

def push(val):
    stack.append(val)

def pop():
    return stack.pop()

def main():
    print(">>  Insert commands")
    while True:
        temp = input(">> ")
        if temp == "q":
            break
        elif temp == "+":
            if len(stack) < 2:
                print(">>  Not enough values")
                continue
            push(pop() + pop())
        elif temp == "*":
            if len(stack) < 2:
                print(">>  Not enough values")
                continue
            push(pop() * pop())
        elif temp == "-":
            if len(stack) < 2:
                print(">>  Not enough values")
                continue
            push(pop() - pop())
        else:
            push(int(temp))
        print(stack)


if __name__ == '__main__':
    main()