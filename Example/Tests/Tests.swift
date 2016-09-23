import UIKit
import XCTest
import Redux

/**

Mock Counter

**/
enum CounterAction: ReduxActionType {
    case decrement
    case increment
    case dispatchWithinDispatch(ReduxStore)
}


struct CounterState: AnyEquatable, Equatable {
    var count: Int
}

func == (lhs: CounterState, rhs: CounterState) -> Bool {
    return lhs.count == rhs.count
}


func counterReducer(_ previousState: Any, action: ReduxAction) -> Any {
    var counterState = previousState as! CounterState
    switch action.payload {
    case CounterAction.increment:
        counterState.count = counterState.count + 1
        break
    case CounterAction.decrement:
        counterState.count = counterState.count - 1
        break
    case CounterAction.dispatchWithinDispatch(let store):
        store.dispatch(ReduxAction(payload: CounterAction.increment))
        break
    default:
        break
    }
    return counterState
}



/**

Mock List

**/
enum ListAction: ReduxActionType {
    case append(String)
    case remove
}


struct ListState: AnyEquatable, Equatable {
    var list: [String]
}

func == (lhs: ListState, rhs: ListState) -> Bool {
    return lhs.list == rhs.list
}


func listReducer(_ previousState: Any, action: ReduxAction) -> Any {
    var listState = previousState as! ListState
    switch action.payload {
    case ListAction.append(let str):
        listState.list.append(str)
        break
    case ListAction.remove:
        listState.list.removeLast()
        break
    default:
        break
    }
    return listState
}



/**

Mock App

**/
struct CombineState: ReduxAppState, AnyEquatable, Equatable {
    var count: CounterState
    var list: ListState

    func get(_ key: String) -> AnyEquatable? {
        switch key {
        case "count": return self.count
        case "list": return self.list
        default: return nil
        }
    }

    mutating func set(_ key: String, value: AnyEquatable) {
        switch key {
        case "count":
            self.count = value as! CounterState
            break
        case "list":
            self.list = value as! ListState
            break
        default:
            break
        }
    }
}

func == (lhs: CombineState, rhs: CombineState) -> Bool {
    return lhs.count == rhs.count && lhs.list == rhs.list
}


class Store: StoreType {

    static func configureStore() -> ReduxStore {

        let initialState = CombineState(
            count: CounterState(count: 0),
            list: ListState(list: [String]())
        )

        let reducers: [String: Reducer] = [
            "count": counterReducer,
            "list": listReducer
        ]

        return createStore(
            combineReducers(reducers),
            initialState: initialState
        )
    }

}

extension ReduxStore {

    func getCountState() -> CounterState? {
        return getAppState()!.get("count") as? CounterState
    }

    func getListState() -> ListState? {
        return getAppState()!.get("list") as? ListState
    }
}
