import Foundation

class DependencyContainer {
    enum DependencyType {
        case singletone
        case unique
    }
    
    struct Dependency {
        var type: DependencyType?
        var value: Any?
    }
    
    static let shared = DependencyContainer()
    private var dependencies = [String: Dependency]()
    
    private init() { }
    
    func register<T: AnyObject>(
        type: T.Type,
        of dependencyType: DependencyType,
        initMethod: @escaping () -> T
    ) {
        let typeName = String(describing: type)
        var dependency = Dependency()
        
        dependency.type = dependencyType
        
        switch dependencyType {
        case .singletone:
            dependency.value = initMethod()
        case .unique:
            dependency.value = initMethod
        }
        
        dependencies[typeName] = dependency
    }
    
    func resolve<T>(
        type: T.Type
    ) -> T? {
        let typeName = String(describing: type)
        
        if let dependency = dependencies[typeName] {
            switch dependency.type {
            case .singletone:
                return dependency.value as? T
            case .unique:
                return (dependency.value as? () -> Void)?() as? T
            case .none:
                break
            }
        }
        
        return nil
    }
}
