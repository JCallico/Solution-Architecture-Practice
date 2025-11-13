# Design Patterns Catalog

## Overview

Classical object-oriented design patterns for solving recurring design problems. These patterns provide proven solutions for code organization, object creation, and behavioral interactions.

---

## Creational Patterns

### 1. Factory Method

**Problem:** Creating objects with complex initialization logic.

**Solution:** Create via factory method instead of constructor.

```python
# Without factory (hard to extend)
if type == "pdf":
    report = PDFReport()
elif type == "excel":
    report = ExcelReport()

# With factory (easy to extend)
class ReportFactory:
    @staticmethod
    def create(type):
        reports = {
            "pdf": PDFReport,
            "excel": ExcelReport,
            "html": HTMLReport
        }
        return reports[type]()

# Usage
report = ReportFactory.create("pdf")
```

---

### 2. Builder Pattern

**Problem:** Creating objects with many optional parameters.

**Solution:** Build object step-by-step with fluent API.

```python
# Without builder (confusing)
order = Order(123, "John", "john@example.com", 
              "123 Main", "New York", "NY", "10001",
              "VISA", "4111...", "12/25")

# With builder (clear)
order = (OrderBuilder()
    .with_customer_id(123)
    .with_customer_name("John")
    .with_email("john@example.com")
    .with_address("123 Main", "New York", "NY", "10001")
    .with_payment("VISA", "4111...", "12/25")
    .build())
```

---

### 3. Singleton

**Problem:** Need single shared instance throughout application.

**Solution:** Ensure only one instance can exist.

```python
class DatabaseConnection:
    _instance = None
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance.connect()
        return cls._instance

# Usage
db1 = DatabaseConnection()
db2 = DatabaseConnection()
assert db1 is db2  # Same instance
```

---

## Structural Patterns

### 4. Adapter Pattern

**Problem:** Interface incompatibility between components.

**Solution:** Adapter translates between interfaces.

```
Old Interface → Adapter → New Interface
  legacy()                 modern()
```

```python
class LegacySystem:
    def legacy_method(self):
        return "legacy data"

class ModernAdapter:
    def __init__(self, legacy):
        self.legacy = legacy
    
    def modern_method(self):
        return self.legacy.legacy_method()

# Usage
legacy = LegacySystem()
adapter = ModernAdapter(legacy)
data = adapter.modern_method()
```

---

### 5. Decorator Pattern

**Problem:** Add responsibilities to object dynamically.

**Solution:** Wrap object with decorator.

```python
# Simple Logger
class Logger:
    def __init__(self, service):
        self.service = service
    
    def perform(self):
        print("Starting operation")
        result = self.service.perform()
        print("Operation complete")
        return result

# Usage
service = UserService()
logged = Logger(service)
cached = Cache(logged)
result = cached.perform()  # Logs + caches
```

---

### 6. Facade Pattern

**Problem:** Complex subsystem is hard to use.

**Solution:** Provide simplified interface (facade).

```python
# Without facade (complex)
db = Database()
cache = Cache()
logger = Logger()
validator = Validator()

# 10 lines of complex interaction code

# With facade (simple)
service = UserService()
user = service.get_user(123)
```

---

### 7. Proxy Pattern

**Problem:** Need to control access to object.

**Solution:** Use proxy that controls access.

```python
class UserServiceProxy:
    def __init__(self, service):
        self.service = service
    
    def get_user(self, user_id):
        # Check cache first
        if user_id in self.cache:
            return self.cache[user_id]
        
        # Load from service
        user = self.service.get_user(user_id)
        
        # Cache result
        self.cache[user_id] = user
        return user
```

---

## Behavioral Patterns

### 8. Observer Pattern

**Problem:** Object changes need to notify many subscribers.

**Solution:** Observers register to be notified of changes.

```python
class Subject:
    def __init__(self):
        self.observers = []
    
    def attach(self, observer):
        self.observers.append(observer)
    
    def notify(self, event):
        for observer in self.observers:
            observer.update(event)

# Usage
order = Order()
order.attach(EmailNotifier())
order.attach(InventoryUpdater())
order.complete()  # Both notified
```

---

### 9. Strategy Pattern

**Problem:** Multiple algorithms for same problem.

**Solution:** Strategy classes encapsulate algorithms.

```python
class PaymentProcessor:
    def __init__(self, strategy):
        self.strategy = strategy
    
    def process(self, amount):
        return self.strategy.pay(amount)

class CreditCardPayment:
    def pay(self, amount):
        # Credit card logic
        pass

class PayPalPayment:
    def pay(self, amount):
        # PayPal logic
        pass

# Usage
processor = PaymentProcessor(CreditCardPayment())
processor.process(100)

processor = PaymentProcessor(PayPalPayment())
processor.process(100)
```

---

### 10. Command Pattern

**Problem:** Encapsulate requests as objects.

**Solution:** Command object encapsulates request.

```python
class Command:
    def execute(self):
        pass

class CreateUserCommand(Command):
    def __init__(self, user_data):
        self.user_data = user_data
    
    def execute(self):
        return UserService.create(self.user_data)

# Usage
cmd = CreateUserCommand({"name": "John"})
cmd.execute()
```

---

## Architectural Patterns

### 11. Model-View-Controller (MVC)

**Problem:** Need to separate concerns in UI application.

**Solution:** Separate Model (data), View (UI), Controller (logic).

```
User Input
    ↓
Controller (handle action)
    ↓
Model (update data)
    ↓
View (render UI)
    ↓
Display to user
```

---

### 12. Model-View-ViewModel (MVVM)

**Problem:** Data binding between UI and business logic.

**Solution:** ViewModel bridges Model and View.

```
View (UI) ←→ ViewModel ←→ Model (Data)
           (two-way binding)
```

---

## References

- [Gang of Four Design Patterns](https://en.wikipedia.org/wiki/Design_Patterns)
- [Refactoring Guru Patterns](https://refactoring.guru/design-patterns)

### Behavioral Patterns
- Chain of Responsibility
- Command
- Iterator
- Mediator
- Memento
- Observer
- State
- Strategy
- Template Method
- Visitor

### Architectural Patterns
- Layered Architecture
- Event-Driven Architecture
- Microkernel
- Space-Based Architecture

## Related Resources

- [Architecture Patterns Overview](./README.md)
- [Domain-Driven Design](../../frameworks/domain-driven-design.md)

---

**Status:** Placeholder  
**Last Updated:** November 2025
