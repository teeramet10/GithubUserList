//
//  GitHubUserListTests.swift
//  GitHubUserListTests
//
//  Created by Teeramet Kanchanapiroj on 24/3/2564 BE.
//

import XCTest
@testable import GitHubUserList

class UserListViewModelTests: XCTestCase {

    var viewModel : UsetListViewModel!
    var dataSource : MockGitHubUserDataSource!
    var localDataSource : MockLocalGitHubUserDataSource!
    var repository :GitHubUserRepositoryProtocol!
    var localDataProvider : MockFavoriteLocalDataProvider!
    override func setUp() {
        super.setUp()
        dataSource = MockGitHubUserDataSource()
        localDataProvider = MockFavoriteLocalDataProvider()
        localDataSource = MockLocalGitHubUserDataSource(localDataProvider)
        repository = GitHubUserRepository(dataSource, localDataSource)
        viewModel = UsetListViewModel(repository)
    }

    override func tearDown() {
        self.viewModel = nil
        self.dataSource = nil
        self.localDataSource = nil
        self.repository = nil
        self.localDataProvider = nil
        super.tearDown()
    }

    func test_getGitHubUsersSuccess(){
        let expectation = XCTestExpectation(description: "data callback")
        let loadingExpectation = XCTestExpectation(description: "loading")
        localDataSource.isSuccess = true
        dataSource.isSuccess = true
        viewModel.output.onLoadDataSuccess = { isEmpty in
            XCTAssert(true)
            XCTAssertFalse(isEmpty)
            expectation.fulfill()
        }
        viewModel.output.showError = { _ in
            XCTFail()
        }
        viewModel.output.showLoading = { _ in
            XCTAssert(true)
            loadingExpectation.fulfill()
        }
        viewModel.fetchUser("")
        wait(for: [expectation,loadingExpectation], timeout: 5)
    }

    func test_getGitHubUsersFailed(){
        let errorExpectation = XCTestExpectation(description: "error event")
        let loadingExpectation = XCTestExpectation(description: "loading")
        dataSource.isSuccess = false
        viewModel.output.onLoadDataSuccess = { isEmpty in
            XCTFail()
        }
        viewModel.output.showError = { errorMessage in
            XCTAssert(true)
            errorExpectation.fulfill()
        }

        viewModel.output.showLoading = { isLoading in
            XCTAssert(true)
            loadingExpectation.fulfill()
        }

        viewModel.fetchUser("")
        wait(for: [errorExpectation,loadingExpectation], timeout: 5)
    }

    func test_getGitHubUsersEmpty(){
        let expectation = XCTestExpectation(description: "data callback")
        let loadingExpectation = XCTestExpectation(description: "loading")
        dataSource.isSuccess = true
        dataSource.isEmpty = true
        localDataSource.isSuccess = true
        viewModel.output.onLoadDataSuccess = { isEmpty in
            XCTAssertTrue(isEmpty)
            expectation.fulfill()
        }
        viewModel.output.showError = { errorMessage in
            XCTFail()
        }

        viewModel.output.showLoading = { isLoading in
            XCTAssert(true)
            loadingExpectation.fulfill()
        }

        viewModel.fetchUser("")
        wait(for: [expectation,loadingExpectation], timeout: 5)
    }

    func test_addFavoriteSuccess(){
        let expectation = XCTestExpectation(description: "waiting callback insert favorite")
        dataSource.isSuccess = true
        localDataSource.isSuccess = true
        localDataProvider.isSuccess = true
        let model = GitHubUserModel()
        model.id = 1
        viewModel.userList = [model]
        viewModel.filterUserList = [model]
        viewModel.output.onInsertFavoriteSuccess = { index in
            XCTAssertTrue(index == 0)
            expectation.fulfill()
        }
        viewModel.output.onInsertFavoriteFailed = { _ in
            XCTFail()
        }

        viewModel.input.didAddFavorite(data: model, 0)
        wait(for: [expectation], timeout: 5)
    }

    func test_addFavoriteFailed(){
        let expectation = XCTestExpectation(description: "waiting callback insert favorite")
        dataSource.isSuccess = false
        localDataSource.isSuccess = false
        let model = GitHubUserModel()
        model.id = 1
        viewModel.userList = [model]
        viewModel.output.onInsertFavoriteSuccess = { index in
            XCTFail()
        }
        viewModel.output.onInsertFavoriteFailed = { _ in
            XCTAssertTrue(true)
            expectation.fulfill()
        }

        viewModel.input.didAddFavorite(data: model, 0)
        wait(for: [expectation], timeout: 5)
    }

    func test_addFavoriteWithoutId(){
        let expectation = XCTestExpectation(description: "waiting callback insert favorite")
        dataSource.isSuccess = true
        localDataSource.isSuccess = true
        viewModel.userList = [GitHubUserModel()]
        viewModel.output.onInsertFavoriteSuccess = { index in
            XCTFail()
        }
        viewModel.output.onInsertFavoriteFailed = { _ in
            XCTAssertTrue(true)
            expectation.fulfill()
        }

        viewModel.input.didAddFavorite(data: GitHubUserModel(), 0)
        wait(for: [expectation], timeout: 5)
    }

    func test_removeFavoriteSuccess(){
        let expectation = XCTestExpectation(description: "waiting callback remove favorite")
        dataSource.isSuccess = true
        localDataSource.isSuccess = true
        localDataProvider.isSuccess = true
        viewModel.isFilterFavorite = false
        let model = GitHubUserModel()
        model.id = 1
        viewModel.userList = [model]
        viewModel.filterUserList = [model]
        viewModel.output.onRemoveFavoriteSuccess = { _ , _ in
            XCTFail()
        }
        viewModel.output.onRemoveFavoriteFailed = { _ in
            XCTFail()
        }
        viewModel.output.onReloadRemoveFavoriteSuccess = { index  in
            XCTAssertTrue(index == 0)
            XCTAssertTrue(true)
            expectation.fulfill()
        }
        viewModel.input.didRemoveFavorite(data: model, 0)
        wait(for: [expectation], timeout: 20)
    }

    func test_removeFavoriteInFilterSuccess(){
        let expectation = XCTestExpectation(description: "waiting callback remove favorite")
        dataSource.isSuccess = true
        localDataSource.isSuccess = true
        localDataProvider.isSuccess = true
        viewModel.isFilterFavorite = true
        let model = GitHubUserModel()
        model.id = 1
        viewModel.userList = [model]
        viewModel.filterUserList = [model]
        viewModel.output.onRemoveFavoriteSuccess = { index, isEmpty in
            XCTAssertTrue(index == 0)
            XCTAssertTrue(isEmpty)
            XCTAssertTrue(true)
            expectation.fulfill()
        }
        viewModel.output.onRemoveFavoriteFailed = { _ in
            XCTFail()
        }
        
        viewModel.output.onReloadRemoveFavoriteSuccess = { _  in
            XCTFail()
        }
        viewModel.input.didRemoveFavorite(data: model, 0)
        wait(for: [expectation], timeout: 5)
    }

    func test_removeFavoriteFailed(){
        let expectation = XCTestExpectation(description: "waiting callback remove favorite")
        dataSource.isSuccess = false
        localDataSource.isSuccess = false
        localDataProvider.isSuccess = false
        let model = GitHubUserModel()
        model.id = 1
        viewModel.userList = [model]
        viewModel.output.onRemoveFavoriteSuccess = { index, isEmpty in
            XCTFail()
        }
        viewModel.output.onRemoveFavoriteFailed = { _ in
            XCTAssertTrue(true)
            expectation.fulfill()
        }

        viewModel.output.onReloadRemoveFavoriteSuccess = { _  in
            XCTFail()
        }
        viewModel.input.didRemoveFavorite(data: model, 0)
        wait(for: [expectation], timeout: 5)
    }

    func test_removeFavoriteIndexOutOfRangeFailed(){
        let expectation = XCTestExpectation(description: "waiting callback remove favorite")
        dataSource.isSuccess = false
        localDataSource.isSuccess = false
        localDataProvider.isSuccess = false
        viewModel.isFilterFavorite = false
        let model = GitHubUserModel()
        viewModel.userList = [model]
        viewModel.output.onRemoveFavoriteSuccess = { index, isEmpty in
            XCTFail()
        }
        viewModel.output.onRemoveFavoriteFailed = { _ in
            XCTAssertTrue(true)
            expectation.fulfill()
        }

        viewModel.output.onReloadRemoveFavoriteSuccess = { _  in
            XCTFail()
        }
        viewModel.input.didRemoveFavorite(data: model, 2)
        wait(for: [expectation], timeout: 10)
    }

    func test_removeFavoriteIndexOutOfRangeInFilterFailed(){
        let expectation = XCTestExpectation(description: "waiting callback remove favorite")
        dataSource.isSuccess = false
        localDataSource.isSuccess = false
        localDataProvider.isSuccess = false
        viewModel.isFilterFavorite = true
        let model = GitHubUserModel()
        viewModel.userList = [model]
        viewModel.filterUserList = [model]
        viewModel.output.onRemoveFavoriteSuccess = { index, isEmpty in
            XCTFail()
        }
        viewModel.output.onRemoveFavoriteFailed = { _ in
            XCTAssertTrue(true)
            expectation.fulfill()
        }

        viewModel.output.onReloadRemoveFavoriteSuccess = { _  in
            XCTFail()
        }
        viewModel.input.didRemoveFavorite(data: model, 2)
        wait(for: [expectation], timeout: 10)
    }

    func test_removeFavoriteWithoutId(){
        let expectation = XCTestExpectation(description: "waiting callback remove favorite")
        dataSource.isSuccess = false
        localDataSource.isSuccess = false
        localDataProvider.isSuccess = false
        let model = GitHubUserModel()
        viewModel.userList = [model]
        viewModel.output.onRemoveFavoriteSuccess = { _ , _ in
            XCTFail()
        }
        viewModel.output.onRemoveFavoriteFailed = { _ in
            XCTAssertTrue(true)
            expectation.fulfill()
        }
        viewModel.output.onReloadRemoveFavoriteSuccess = { _  in
            XCTFail()
        }
        viewModel.input.didRemoveFavorite(data: model, 0)
        wait(for: [expectation], timeout: 10)
    }

    func test_searchGitHubUsersSuccess(){
        let expectation = XCTestExpectation(description: "data callback")
        let loadingExpectation = XCTestExpectation(description: "loading")
        localDataSource.isSuccess = true
        dataSource.isSuccess = true
        viewModel.output.onLoadDataSuccess = { isEmpty in
            XCTAssert(true)
            XCTAssertFalse(isEmpty)
            expectation.fulfill()
        }
        viewModel.output.showError = { _ in
            XCTFail()
        }
        viewModel.output.showLoading = { _ in
            XCTAssert(true)
            loadingExpectation.fulfill()
        }
        viewModel.input.fetchUser("test")
        wait(for: [expectation,loadingExpectation], timeout: 10)
    }

    func test_searchGitHubUsersFailed(){
        let expectation = XCTestExpectation(description: "data callback")
        let loadingExpectation = XCTestExpectation(description: "loading")
        localDataSource.isSuccess = false
        dataSource.isSuccess = false
        viewModel.output.onLoadDataSuccess = { isEmpty in
            XCTFail()
        }
        viewModel.output.showError = { _ in
            XCTAssert(true)
            expectation.fulfill()
        }
        viewModel.output.showLoading = { _ in
            XCTAssert(true)
            loadingExpectation.fulfill()
        }
        viewModel.input.fetchUser("test")
        wait(for: [expectation,loadingExpectation], timeout: 10)
    }

    func test_searchGitHubUsersInFilterFavoriteFound(){
        let expectation = XCTestExpectation(description: "data callback")
        let loadingExpectation = XCTestExpectation(description: "loading")
        localDataSource.isSuccess = true
        dataSource.isSuccess = true
        viewModel.isFilterFavorite = true
        let model1 = GitHubUserModel()
        model1.id = 1
        model1.login = "test1"
        let model2 = GitHubUserModel()
        model2.id = 2
        model2.login = "boszty"
        viewModel.userList = [model1,model2]
        viewModel.filterUserList = [model1,model2]
        viewModel.output.onLoadDataSuccess = {[weak self ] isEmpty in
            guard let `self` = self else{return}
            XCTAssertTrue(self.viewModel.filterUserList.count == 1)
            XCTAssert(true)
            XCTAssertFalse(isEmpty)
            expectation.fulfill()
        }
        viewModel.output.showError = { _ in
            XCTFail()
        }
        viewModel.output.showLoading = { _ in
            XCTAssert(true)
            loadingExpectation.fulfill()
        }
        viewModel.input.fetchUser("test")
        wait(for: [expectation,loadingExpectation], timeout: 5)
    }

    func test_searchGitHubUsersInFilterFavoriteNotFound(){
        let expectation = XCTestExpectation(description: "data callback")
        let loadingExpectation = XCTestExpectation(description: "loading")
        localDataSource.isSuccess = true
        dataSource.isSuccess = true
        viewModel.isFilterFavorite = true
        let model1 = GitHubUserModel()
        model1.id = 1
        model1.login = "test1"
        let model2 = GitHubUserModel()
        model2.id = 2
        model2.login = "boszty"
        viewModel.userList = [model1,model2]
        viewModel.filterUserList = [model1,model2]
        viewModel.output.onLoadDataSuccess = { isEmpty in
            XCTAssert(true)
            XCTAssertTrue(isEmpty)
            expectation.fulfill()
        }
        viewModel.output.showError = { _ in
            XCTFail()
        }
        viewModel.output.showLoading = { _ in
            XCTAssert(true)
            loadingExpectation.fulfill()
        }
        viewModel.input.fetchUser("test555")
        wait(for: [expectation,loadingExpectation], timeout: 5)
    }

    func test_sortUserNameSuccess(){
        let expectation = XCTestExpectation(description: "sort callback")
        let model1 = GitHubUserModel()
        model1.id = 1
        model1.login = "test_b"
        let model2 = GitHubUserModel()
        model2.id = 2
        model2.login = "test_a"
        viewModel.userList = [model1,model2]
        viewModel.filterUserList = [model1,model2]
        viewModel.output.onSortDataSuccess = {[weak self] isEmpty in
            guard let `self` = self else{return}
            XCTAssert(self.viewModel.filterUserList[0].login == "test_a")
            XCTAssert(self.viewModel.filterUserList[1].login == "test_b")
            XCTAssert(true)
            XCTAssertFalse(isEmpty)
            expectation.fulfill()
        }
        viewModel.input.sortList(.name)
        wait(for: [expectation], timeout: 10)
    }


    func test_sortUserFavoriteSuccess(){
        let expectation = XCTestExpectation(description: "sort callback")
        let model1 = GitHubUserModel()
        model1.id = 1
        model1.login = "test_b"
        model1.isFavorite = false
        let model2 = GitHubUserModel()
        model2.id = 2
        model2.login = "test_a"
        model2.isFavorite = true
        viewModel.userList = [model1,model2]
        viewModel.filterUserList = [model1,model2]
        viewModel.output.onSortDataSuccess = {[weak self] isEmpty in
            guard let `self` = self else{return}
            XCTAssertTrue(self.viewModel.filterUserList[0].isFavorite)
            XCTAssertFalse(self.viewModel.filterUserList[1].isFavorite)
            XCTAssert(true)
            XCTAssertFalse(isEmpty)
            expectation.fulfill()
        }
        viewModel.input.sortList(.favorite)
        wait(for: [expectation], timeout: 10)
    }


    func test_sortUserNoneSuccess(){
        let expectation = XCTestExpectation(description: "sort callback")
        let model1 = GitHubUserModel()
        model1.id = 1
        model1.login = "test_b"
        model1.isFavorite = false
        let model2 = GitHubUserModel()
        model2.id = 2
        model2.login = "test_a"
        model2.isFavorite = true
        viewModel.userList = [model1,model2]
        viewModel.filterUserList = [model1,model2]
        viewModel.output.onSortDataSuccess = {[weak self] isEmpty in
            guard let `self` = self else{return}
            XCTAssertFalse(self.viewModel.filterUserList[0].isFavorite)
            XCTAssertTrue(self.viewModel.filterUserList[1].isFavorite)
            XCTAssertTrue(self.viewModel.filterUserList[0].id == 1)
            XCTAssertTrue(self.viewModel.filterUserList[1].id == 2)
            XCTAssertTrue(self.viewModel.filterUserList[0].login == "test_b")
            XCTAssertTrue(self.viewModel.filterUserList[1].login == "test_a")
            XCTAssert(true)
            XCTAssertFalse(isEmpty)
            expectation.fulfill()
        }
        viewModel.input.sortList(.none)
        wait(for: [expectation], timeout: 10)
    }

    func test_showSortPopupSortTypeNameSuccess(){
        let view = UIView()
        let expectation = XCTestExpectation(description: "show popup callback")
        viewModel.sortType = .name
        viewModel.output.showSortView = {(sortType,newView) in
            XCTAssert(view == newView)
            XCTAssert(sortType == .name)
            expectation.fulfill()
        }
        viewModel.input.getSortType(view)
        wait(for: [expectation], timeout: 10)
    }

    func test_showSortPopupSortTypeFavoriteSuccess(){
        let view = UIView()
        let expectation = XCTestExpectation(description: "show popup callback")
        viewModel.sortType = .favorite
        viewModel.output.showSortView = {(sortType,newView) in
            XCTAssert(view == newView)
            XCTAssert(sortType == .favorite)
            expectation.fulfill()
        }
        viewModel.input.getSortType(view)
        wait(for: [expectation], timeout: 10)
    }

    func test_showSortPopupSortTypeNoneSuccess(){
        let view = UIView()
        let expectation = XCTestExpectation(description: "show popup callback")
        viewModel.sortType = .none
        viewModel.output.showSortView = {(sortType,newView) in
            XCTAssert(view == newView)
            XCTAssert(sortType == .none)
            expectation.fulfill()
        }
        viewModel.getSortType(view)
        wait(for: [expectation], timeout: 10)
    }

    func test_filterFavoriteSuccess(){
        let expectation = XCTestExpectation(description: "load data callback")
        let filterExpectation = XCTestExpectation(description: "change filter status callback")
        localDataSource.isSuccess = true
        localDataSource.isEmpty = false
        localDataProvider.isSuccess = true
        viewModel.sortType = .none
        viewModel.isFilterFavorite = false
        viewModel.output.onLoadDataSuccess = { [weak self] isEmpty in
            guard let `self` = self else{return}
            XCTAssertTrue(self.viewModel.filterUserList.first?.isFavorite ?? false)
            XCTAssert(true)
            XCTAssertFalse(isEmpty)
            expectation.fulfill()
        }

        viewModel.output.onFilterDataSuccess = {[weak self] image in
            guard let `self` = self else{return}
            XCTAssertTrue( self.viewModel.isFilterFavorite)
            XCTAssertNotNil(image)
            filterExpectation.fulfill()

        }
        viewModel.input.filterFavorite("")
        wait(for: [expectation,filterExpectation], timeout: 30)
    }

    func test_filterFavoriteFailed(){
        let expectation = XCTestExpectation(description: "load data callback")
        let filterExpectation = XCTestExpectation(description: "change filter status callback")
        localDataSource.isSuccess = true
        localDataSource.isEmpty = false
        localDataProvider.isSuccess = false
        viewModel.sortType = .none
        viewModel.isFilterFavorite = false
        viewModel.output.onLoadDataSuccess = { [weak self] isEmpty in
            guard let `self` = self else{return}
            XCTAssert(true)
            XCTAssertTrue(isEmpty)
            expectation.fulfill()
        }

        viewModel.output.onFilterDataSuccess = {[weak self] image in
            guard let `self` = self else{return}
            XCTAssertTrue( self.viewModel.isFilterFavorite)
            XCTAssertNotNil(image)
            filterExpectation.fulfill()

        }
        viewModel.input.filterFavorite("")
        wait(for: [expectation,filterExpectation], timeout: 30)
    }

    func test_unfilterFavorite(){
        let expectation = XCTestExpectation(description: "load data callback")
        let filterExpectation = XCTestExpectation(description: "change filter status callback")
        viewModel.sortType = .none
        localDataSource.isSuccess = true
        dataSource.isSuccess = true
        viewModel.isFilterFavorite = true
        viewModel.output.onLoadDataSuccess = { isEmpty in
            XCTAssert(true)
            XCTAssertFalse(isEmpty)
            expectation.fulfill()
        }

        viewModel.output.onFilterDataSuccess = {[weak self] image in
            guard let `self` = self else{return}
            XCTAssertFalse( self.viewModel.isFilterFavorite)
            XCTAssertNotNil(image)
            filterExpectation.fulfill()

        }
        viewModel.input.filterFavorite("")
        wait(for: [expectation,filterExpectation], timeout: 30)
    }

    func test_bufferSearch(){
        let expectation = XCTestExpectation(description: "search callback")
        localDataSource.isSuccess = true
        localDataSource.isEmpty = true
        localDataProvider.isSuccess = true
        let textSearch1 = "test"
        viewModel.output.onSearch = { searchText in
            XCTAssert(true)
            XCTAssertTrue(searchText == textSearch1)
            expectation.fulfill()
        }
        viewModel.input.didBufferSearch(textSearch1)
        wait(for: [expectation], timeout: 10)
    }

    func test_bufferSearchTextChangeTwice(){
        let expectation = XCTestExpectation(description: "search callback")
        localDataSource.isSuccess = true
        localDataSource.isEmpty = true
        localDataProvider.isSuccess = true
        let textSearch1 = "test"
        let textSearch2 = "github user"
        viewModel.output.onSearch = { searchText in
            XCTAssert(true)
            XCTAssertTrue(searchText == textSearch2)
            expectation.fulfill()
        }
        viewModel.input.didBufferSearch(textSearch1)
        viewModel.input.didBufferSearch(textSearch2)
        wait(for: [expectation], timeout: 10)
    }
}
