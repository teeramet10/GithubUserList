//
//  UserRepositoryListTests.swift
//  GitHubUserListTests
//
//  Created by Teeramet Kanchanapiroj on 27/3/2564 BE.
//

import XCTest
@testable import GitHubUserList

class UserRepositoryListTests: XCTestCase {
    var viewModel : UserRepositoryListViewModel!
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
        viewModel = UserRepositoryListViewModel(repository)
    }

    override func tearDown() {
        self.viewModel = nil
        self.dataSource = nil
        self.localDataSource = nil
        self.repository = nil
        self.localDataProvider = nil
        super.tearDown()
    }
    func test_getUserSuccess(){
        let expectation = XCTestExpectation(description: "get user")
        let user = GitHubUserModel()
        user.login = "test1"

        viewModel.gitHubUser = user
        viewModel.output.onSetUser = {gitHubUser in
            XCTAssert(gitHubUser.login == "test1")
            expectation.fulfill()
        }
        viewModel.output.onGetUserFailed = { _ in
            XCTFail()
        }
        viewModel.input.getUser()
        wait(for: [expectation], timeout: 5)
    }

    func test_getUserFailed(){
        let expectation = XCTestExpectation(description: "get user")

        viewModel.gitHubUser = nil
        viewModel.output.onSetUser = {gitHubUser in
            XCTFail()
        }
        viewModel.output.onGetUserFailed = { _ in
            XCTAssertTrue(true)
            expectation.fulfill()
        }
        viewModel.input.getUser()
        wait(for: [expectation], timeout: 5)
    }

    func test_getRepositoriesFailed(){
        let user = GitHubUserModel()
        user.login = "test1"
        viewModel.gitHubUser = user
        let expectation = XCTestExpectation(description: "data callback")
        let loadingExpectation = XCTestExpectation(description: "loading")
        localDataSource.isSuccess = false
        dataSource.isSuccess = false
        viewModel.output.onFetchDataSuccess = { isEmpty in
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
        viewModel.input.getRepositories()
        wait(for: [expectation,loadingExpectation], timeout: 5)
    }

    func test_getRepositoriesSuccess(){
        let user = GitHubUserModel()
        user.login = "test1"
        viewModel.gitHubUser = user
        let expectation = XCTestExpectation(description: "data callback")
        let loadingExpectation = XCTestExpectation(description: "loading")
        localDataSource.isSuccess = true
        dataSource.isSuccess = true
        viewModel.output.onFetchDataSuccess = { isEmpty in
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
        viewModel.input.getRepositories()
        wait(for: [expectation,loadingExpectation], timeout: 5)
    }

    func test_getRepositoriesEmpty(){
        let expectation = XCTestExpectation(description: "data callback")
        let loadingExpectation = XCTestExpectation(description: "loading")
        let user = GitHubUserModel()
        user.login = "test1"
        viewModel.gitHubUser = user
        dataSource.isSuccess = true
        dataSource.isEmpty = true
        viewModel.output.onFetchDataSuccess = { isEmpty in
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
        viewModel.input.getRepositories()
        wait(for: [expectation,loadingExpectation], timeout: 5)
    }

    func test_getRepositoriesEmptyName(){
        let expectation = XCTestExpectation(description: "data callback")
        let loadingExpectation = XCTestExpectation(description: "loading")
        let user = GitHubUserModel()
        user.login = ""
        viewModel.gitHubUser = user
        dataSource.isSuccess = true
        dataSource.isEmpty = true
        viewModel.output.onFetchDataSuccess = { _ in
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
        viewModel.input.getRepositories()
        wait(for: [expectation,loadingExpectation], timeout: 5)
    }
}
