# Open Source DDI Solution


```gql
mutation {
  CoreReadOnlyRepositoryCreate(
    data: {
      name: { value: "ddi" },
      location: { value: "https://github.com/marcom4rtinez/ddi.git" },
      ref: { value: "main" },
    }
  ) {
    ok
    object {
      id
    }
  }
}
```